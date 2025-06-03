import SwiftUI

struct ToastView: View {
  let message: String
  let type: NitroToastType

  var backgroundColor: Color {
    switch type {
    case .success:
      return .green
    case .error:
      return .red
    case .info:
      return .blue
    case .warning:
      return .yellow
    }
  }

  var body: some View {
    Text(message)
      .font(.system(size: 16, weight: .medium))
      .foregroundColor(.white)
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .background(backgroundColor)
      .cornerRadius(8)
      .shadow(radius: 2)
      .padding(.horizontal, 20)
      .allowsHitTesting(true)
  }
}
