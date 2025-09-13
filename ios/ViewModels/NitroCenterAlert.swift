//
//  NitroCenterAlert.swift
//  NitroToast
//
//  Created by iMacBunny on 9/10/25.
//

import SwiftUI

// MARK: - Alert Model

struct Alert {
    let id = UUID().uuidString
    var title: String?
    var message: String
    var config: NitroToastAlertConfig
}

extension Alert {
    var backgroundColor: Color {
        if let hex = config.backgroundColor { Color(hex) }
        else { Color(.systemBackground) }
    }
    
    var iconTint: Color {
        if let hex = config.iconTint { return Color(hex) }
        else {
            switch config.type {
            case .success: return .toastSuccess
            case .error:   return .toastError
            case .info:    return .toastInfo
            case .warning: return .toastWarning
            default:       return .toastDefault
            }
        }
    }
    
    var titleColor: Color {
        if let hex = config.titleColor { Color(hex) }
        else { .primary }
    }

    var messageColor: Color {
        if let hex = config.messageColor { Color(hex) }
        else { .secondary }
    }
}

// MARK: - ViewModel

@MainActor
final class CenterAlertViewModel: ObservableObject {
    static let shared = CenterAlertViewModel()
    private var dismissTask: Task<Void, Never>?
    private var window: UIWindow?
    
    @Published var isPresented: Bool = false
    @Published var alert: Alert?
    
    // Show Alert
    func showAlert(title: String? = nil,
                   message: String,
                   config: NitroToastAlertConfig = .init()) {
        if window == nil { attachWindow() }
        
        dismissTask?.cancel()
        
        if config.haptics == true {
            triggerHaptics(for: config.type)
        }
        withAnimation(.spring(response: 0.42, dampingFraction: 0.85)) {
            alert = Alert(title: title, message: message, config: config)
            isPresented = true
        }
        
        // Auto-dismiss
        guard config.duration > 0 else { return }
        dismissTask = Task { [weak self] in
                    try? await Task.sleep(nanoseconds: UInt64(config.duration) * 1_000_000)
                     self?.dismiss()
                }
    }
    
    // Dismiss Alert
    func dismiss() {
        dismissTask?.cancel()
                dismissTask = nil
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.95)) {
            isPresented = false
        }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 300_000_000)
            if !self.isPresented { detachWindow() }
        }
    }
    
    // MARK: - Window Handling
    private func attachWindow() {
        let host = UIHostingController(rootView: CenterAlertRoot())
        host.view.backgroundColor = .clear
        let win = UIWindow(frame: UIScreen.main.bounds)
        win.windowLevel = .alert + 2
        win.rootViewController = host
        win.isHidden = false
        window = win
    }
    
    private func detachWindow() {
        window?.isHidden = true
        window?.rootViewController = nil
        window = nil
    }
    
    // MARK: - Haptics
    private func triggerHaptics(for type: ToastType) {
        let gen = UINotificationFeedbackGenerator()
        switch type {
        case .success: gen.notificationOccurred(.success)
        case .error:   gen.notificationOccurred(.error)
        case .warning: gen.notificationOccurred(.warning)
        default: UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}

// MARK: - Root

private struct CenterAlertRoot: View {
    @ObservedObject private var vm = CenterAlertViewModel.shared
    
    var body: some View {
        ZStack {
            if vm.isPresented, let alert = vm.alert {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                CenterAlertCard(alert: alert)
                    .padding(24)
                    .frame(maxWidth: 360)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if alert.config.allowsTapToDismiss { vm.dismiss() }
                    }
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.9).combined(with: .opacity),
                        removal:   .scale(scale: 0.92).combined(with: .opacity)
                    ))
            }
        }
        .animation(.easeInOut(duration: 0.18), value: vm.isPresented)
    }
}

// MARK: - Card

private struct CenterAlertCard: View {
    let alert: Alert
    @State private var pop: CGFloat = 0.94
    @State private var iconPulse = false
    
    var body: some View {
        VStack(spacing: 14) {
            IconView(type: alert.config.type, tint: alert.iconTint)
                .frame(width: 56, height: 56)
                .scaleEffect(iconPulse ? 1.0 : 0.8)
                .animation(.spring(response: 0.42, dampingFraction: 0.7), value: iconPulse)
            
            if let title = alert.title, !title.isEmpty {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(alert.titleColor)
                    .multilineTextAlignment(.center)
            }
            
            Text(alert.message)
                .font(.subheadline)
                .foregroundStyle(alert.messageColor)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(alert.backgroundColor)
                .shadow(color: .black.opacity(0.12), radius: 14, x: 0, y: 8)
        )
        .scaleEffect(pop)
        .onAppear {
            withAnimation(.spring(response: 0.26, dampingFraction: 0.7)) { pop = 1.02 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) { pop = 1.0 }
            }
            iconPulse = true
        }
    }
}

// MARK: - Icon

private struct IconView: View {
    let type: ToastType
    let tint: Color
    
    @State private var ringTrim: CGFloat = 0.0
    @State private var markTrim: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(tint.opacity(0.25), lineWidth: 6)
            
            // Animated ring
            Circle()
                .trim(from: 0, to: ringTrim)
                .stroke(tint, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            // Mark / Cross / Info
            markView
            
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.35)) { ringTrim = 1.0 }
            withAnimation(.easeOut(duration: 0.42).delay(0.08)) { markTrim = 1.0 }
        }
    }
    
    @ViewBuilder
    private var markView: some View {
        switch type {
        case .success:
            CheckmarkShape()
                .trim(from: 0, to: markTrim)
                .stroke(tint, style: StrokeStyle(lineWidth: 6, lineCap: .round))
        case .error:
            CrossShape()
                .trim(from: 0, to: markTrim)
                .stroke(tint, style: StrokeStyle(lineWidth: 6, lineCap: .round))
        case .warning:
            ExclaimShape()
                .trim(from: 0, to: markTrim)
                .stroke(tint, style: StrokeStyle(lineWidth: 6, lineCap: .round))
        case .info:
            InfoIShape()
                .trim(from: 0, to: markTrim)
                .stroke(tint, style: StrokeStyle(lineWidth: 6, lineCap: .round))
            
            //      case .custom(let systemImage):
            //        // Overlay with system image instead of Shape
            //        Image(systemName: systemImage)
            //          .resizable()
            //          .scaledToFit()
            //          .foregroundStyle(tint)
            //      }
        case .loading:
            InfoIShape()
                .trim(from: 0, to: markTrim)
                .stroke(tint, style: StrokeStyle(lineWidth: 6, lineCap: .round))
        case .default:
            InfoIShape()
                .trim(from: 0, to: markTrim)
                .stroke(tint, style: StrokeStyle(lineWidth: 6, lineCap: .round))
        }
    }
    
    // MARK: - Shapes
    
    private struct CheckmarkShape: Shape {
        func path(in rect: CGRect) -> Path {
            var p = Path()
            let w = rect.width, h = rect.height
            p.move(to: CGPoint(x: 0.28*w, y: 0.52*h))
            p.addLine(to: CGPoint(x: 0.45*w, y: 0.68*h))
            p.addLine(to: CGPoint(x: 0.75*w, y: 0.36*h))
            return p
        }
    }
    
    private struct CrossShape: Shape {
        func path(in rect: CGRect) -> Path {
            var p = Path()
            let w = rect.width, h = rect.height
            p.move(to: CGPoint(x: 0.30*w, y: 0.30*h))
            p.addLine(to: CGPoint(x: 0.70*w, y: 0.70*h))
            p.move(to: CGPoint(x: 0.70*w, y: 0.30*h))
            p.addLine(to: CGPoint(x: 0.30*w, y: 0.70*h))
            return p
        }
    }
    
    private struct ExclaimShape: Shape {
        func path(in rect: CGRect) -> Path {
            var p = Path()
            let w = rect.width, h = rect.height
            // line
            p.move(to: CGPoint(x: 0.5*w, y: 0.25*h))
            p.addLine(to: CGPoint(x: 0.5*w, y: 0.62*h))
            // dot
            p.move(to: CGPoint(x: 0.5*w, y: 0.78*h))
            p.addLine(to: CGPoint(x: 0.5*w, y: 0.78*h))
            return p
        }
    }
    
    private struct InfoIShape: Shape {
        func path(in rect: CGRect) -> Path {
            var p = Path()
            let w = rect.width, h = rect.height
            // dot
            p.move(to: CGPoint(x: 0.5*w, y: 0.28*h))
            p.addLine(to: CGPoint(x: 0.5*w, y: 0.28*h))
            // stem
            p.move(to: CGPoint(x: 0.5*w, y: 0.42*h))
            p.addLine(to: CGPoint(x: 0.5*w, y: 0.70*h))
            return p
        }
    }
    
    private struct EmptyShape: Shape {
        func path(in rect: CGRect) -> Path { Path() }
    }
}

