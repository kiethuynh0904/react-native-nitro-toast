//
//  DelayedAppearView.swift
//  NitroToast
//
//  Created by iMacBunny on 6/7/25.
//

import SwiftUI

/// A SwiftUI view that delays its appearance to fix missing transition issues in React Native.
///
/// Used to ensure transitions like `.move` and `.opacity` work correctly when views appear
/// immediately after a window is shown from React Native.
struct DelayedAppearView<Content: View>: View {
    @State private var show = false
    let delay: Double
    let content: () -> Content
    
    init(delay: Double = 0.01, @ViewBuilder content: @escaping () -> Content) {
        self.delay = delay
        self.content = content
    }
    
    
    var body: some View {
        Group {
            if show {
                content()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                withAnimation {
                    show = true
                }
            }
        }
    }
}
