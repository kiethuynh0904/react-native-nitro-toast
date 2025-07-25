//
//  ToastIconView.swift
//  NitroToast
//
//  Created by kiet.huynh on 7/1/25.
//

import SwiftUI

struct ToastIconView: View {
    @ObservedObject var toast: Toast

    var body: some View {
        switch toast.icon {
        case let .system(name, color):
            Image(systemName: name)
                .font(.system(size: 20))
                .foregroundColor(color)

        case let .image(uri):
            if let image = UIImage(contentsOfFile: uri) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
            }

        case let .progress(color):
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: color))
                .frame(width: 20, height: 20)

        case .none:
            EmptyView()
        }
    }
}
