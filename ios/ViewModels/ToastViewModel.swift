//
//  ToastViewModel.swift
//  NitroToast
//
//  Created by kiet.huynh on 6/3/25.
//

import Combine
import SwiftUI

@MainActor
class ToastViewModel: ObservableObject {
    static let shared = ToastViewModel()

    /// Duration of the toast enter/exit and update animations.
    private static let animationDuration: TimeInterval = 0.3

    /// Per-toast auto-dismiss countdown tasks, so they can be cancelled on
    /// dismiss/update instead of running to completion.
    private var countdownTasks: [String: Task<Void, Never>] = [:]

    var toastWindow: UIWindow?

    var isEmpty: Bool { toasts.isEmpty }

    // MARK: Published State

    @Published var toasts: [Toast] = []
    @Published var isExpanded: Bool = false

    func emit(toastId: String, message: String, config: NitroToastConfig) {
        let toast: Toast
        if let existing = toasts.first(where: { $0.id == toastId }) {
            updateToast(existing, with: message, config: config)
            toast = existing
        } else {
            let newToast = Toast(toastId: toastId, message: message, config: config)
            withAnimation(.bouncy) {
                toasts.append(newToast)
            }
            toast = newToast

            // Enforce maxToasts: dismiss the oldest beyond the cap.
            if let max = config.maxToasts, max >= 1 {
                while toasts.count > Int(max) {
                    guard let oldest = toasts.first(where: { $0.id != newToast.id }) else { break }
                    dismiss(oldest.id)
                }
            }
        }

        if config.haptics == true {
            triggerHaptics(for: config.type)
        }

        // Cancel any in-flight countdown for this toast (e.g. on update).
        countdownTasks[toast.id]?.cancel()

        guard config.duration > 0 else {
            countdownTasks[toast.id] = nil
            return
        }

        countdownTasks[toast.id] = Task { [weak self] in
            guard let self else { return }
            var remaining = config.duration / 1000
            let paused = self.pausedStream(for: toast)

            while remaining > 0 {
                if Task.isCancelled { return }

                // Suspend (no polling) until the toast is not paused. CombineLatest
                // emits the current value immediately, so this returns at once if
                // the toast is already active.
                for await isPaused in paused.values {
                    if Task.isCancelled { return }
                    if !isPaused { break }
                }

                let start = Date()
                // Sleep for the remaining time, waking early if it becomes paused.
                let interrupted = await Self.sleep(remaining, interruptedBy: paused)
                if Task.isCancelled { return }
                if interrupted {
                    remaining -= Date().timeIntervalSince(start)
                } else {
                    remaining = 0
                }
            }

            self.dismiss(toast.id)
        }
    }

    /// A stream of the "effective paused" state for a toast: paused while the
    /// stack is expanded or the toast is being held. Emits on every change.
    private func pausedStream(for toast: Toast) -> AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($isExpanded, toast.$isPaused)
            .map { expanded, paused in expanded || paused }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    /// Sleeps for `seconds`, returning `false` if the full time elapsed, or
    /// `true` if `pausedStream` reported a paused state first.
    private static func sleep(
        _ seconds: TimeInterval,
        interruptedBy pausedStream: AnyPublisher<Bool, Never>
    ) async -> Bool {
        await withTaskGroup(of: Bool.self) { group in
            group.addTask {
                try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                return false
            }
            group.addTask {
                for await isPaused in pausedStream.values where isPaused {
                    return true
                }
                return false
            }
            let result = await group.next() ?? false
            group.cancelAll()
            return result
        }
    }

    private func updateToast(_ existing: Toast, with message: String, config: NitroToastConfig) {
        existing.isUpdating = true
        withAnimation {
            existing.message = message
            existing.config = config
        }
        Task {
            try? await Task.sleep(nanoseconds: UInt64(Self.animationDuration * 1_000_000_000))
            existing.isUpdating = false
        }
    }

    func present(toastId: String, message: String, config: NitroToastConfig) {
        /// If the window already exists, just update the toast content
        guard toastWindow == nil else {
            emit(toastId: toastId, message: message, config: config)
            return
        }

        /// Create and configure the hosting controller
        let toastHostView = makeToastView(for: config)
        let host = UIHostingController(rootView: toastHostView)
        host.view.backgroundColor = .clear

        /// Create and present the toast window, bound to the active window scene
        /// (scene-aware — correct on iPad / multi-window / Stage Manager).
        let activeScene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            ?? UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }.first

        let window: PassthroughWindow
        if let activeScene {
            window = PassthroughWindow(windowScene: activeScene)
        } else {
            window = PassthroughWindow(frame: UIScreen.main.bounds)
        }
        window.windowLevel = .alert + 1
        window.rootViewController = host
        window.isHidden = false
        toastWindow = window

        /// Show toast after UI is attached
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.emit(toastId: toastId, message: message, config: config)
        }
    }

    func dismiss(_ toastId: String) {
        guard let index = toasts.firstIndex(where: { $0.id == toastId }) else { return }
        countdownTasks[toastId]?.cancel()
        countdownTasks[toastId] = nil
        toasts[index].isDeleting = true

        withAnimation(.bouncy) {
            toasts.removeAll { $0.id == toastId }
        }

        if isEmpty {
            isExpanded = false
            cleanWindow()
        }
    }

    func dismissAll() {
        countdownTasks.values.forEach { $0.cancel() }
        countdownTasks.removeAll()
        isExpanded = false
        withAnimation(.bouncy) {
            toasts.removeAll()
        }
        cleanWindow()
    }

    private func cleanWindow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.animationDuration) {
            guard self.isEmpty else { return }
            self.toastWindow?.isHidden = true
            self.toastWindow?.rootViewController = nil
            self.toastWindow = nil
        }
    }

    private func makeToastView(for config: NitroToastConfig) -> some View {
        switch config.presentation {
        case .stacked: return AnyView(ToastStackView())
        case .alert: return AnyView(ToastListView())
        }
    }

    private func triggerHaptics(for type: AlertToastType?) {
        let generator = UINotificationFeedbackGenerator()
        switch type {
        case .success:
            generator.notificationOccurred(.success)
        case .error:
            generator.notificationOccurred(.error)
        case .warning:
            generator.notificationOccurred(.warning)
        default:
            let light = UIImpactFeedbackGenerator(style: .light)
            light.impactOccurred()
        }
    }
}
