import SwiftUI

struct ToastView: View {
    var type: NitroToastType
  var message: String

  var body: some View {
    HStack(spacing: 10) {
      Image(systemName: iconName)
        .foregroundColor(.white)
      Text(message)
        .foregroundColor(.white)
        .font(.body)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(backgroundColor)
    .cornerRadius(12)
    .padding(.horizontal)
    .shadow(radius: 6)
  }

  var iconName: String {
    switch type {
    case .success: return "checkmark.circle.fill"
    case .error: return "xmark.octagon.fill"
    case .warning: return "exclamationmark.triangle.fill"
    default: return "info.circle.fill"
    }
  }

  var backgroundColor: Color {
    switch type {
    case .success: return .green
    case .error: return .red
    case .warning: return .orange
    default: return .blue
    }
  }
}
