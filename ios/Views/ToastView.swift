import SwiftUI

struct ToastView: View {
  let message: String
  let type: NitroToastType
  let onRemove: () -> Void

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
    //    Text(message)
    //      .font(.system(size: 16, weight: .medium))
    //      .foregroundColor(.white)
    //      .padding(.horizontal, 16)
    //      .padding(.vertical, 12)
    //      .background(backgroundColor)
    //      .cornerRadius(8)
    //      .shadow(radius: 2)
    //      .padding(.horizontal, 20)
    //      .allowsHitTesting(true)
    HStack(spacing: 12) {
      Image(systemName: "square.and.arrow.up.fill")
      Text(message)
        .font(.callout)
      Spacer(minLength: 0)

      Button {
        onRemove()
      } label: {
        Image(systemName: "xmark.circle.fill")
          .font(.title2)
      }
    }
    .foregroundStyle(Color.primary)
    .padding(.vertical, 12)
    .padding(.leading, 15)
    .padding(.trailing, 10)
    .background {
      Capsule()
        .fill(.background)
        /// Shadows
        .shadow(color: .black.opacity(0.06), radius: 3, x: -1, y: -3)
        .shadow(color: .black.opacity(0.06), radius: 2, x: 1, y: 3)

    }
    .padding(.horizontal, 15)
  }
}
