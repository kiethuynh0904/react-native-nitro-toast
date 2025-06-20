# 🚀 react-native-nitro-toast

A lightweight, native-powered toast notification library for React Native, built with SwiftUI (iOS) and Jetpack Compose (Android). Designed for performance, native feel, and simplicity.

> ⚠️ **Note**: If you need fully customizable layouts using JSX (e.g., image, input, custom buttons), consider using a JavaScript-based solution like [`react-native-toast-message`](https://github.com/calintamas/react-native-toast-message) instead.

## 📋 Requirements

This library is built with [Nitro Modules](https://nitro.margelo.com/), please check the [minimum requirements](https://nitro.margelo.com/docs/minimum-requirements) first.

### System Requirements
- React Native >= 0.75.0
- iOS: Xcode >= 16.0

## 📸 Preview

### 🔔 Alert Style (Default)

![iOS Toast Demo](./docs/demo.gif)

<details>
<summary>🟢 Android</summary>

![Android Toast Demo](./docs/demo-android.gif)
</details>

> 🔥 Seamless native toasts with smooth animations on both iOS and Android.

## ✨ Features

- ✅ **Fully Native**: Built with SwiftUI (iOS) & Jetpack Compose (Android)
- ✅ **Multiple Styles**: `stacked` and `alert` presentation modes
- ✅ **Toast Types**: `success`, `error`, `info`, `warning` and `default`
- ✅ **Customizable**:
  - Auto-dismiss with configurable duration
  - Position at `top` or `bottom`
  - Background opacity control
  - Custom colors for title and message
  - Haptic feedback support  
    - **Android:** If you enable haptics, you must add the `VIBRATE` permission to your `AndroidManifest.xml`:
      ```xml
      <uses-permission android:name="android.permission.VIBRATE" />
      ```
- ✅ **Performance**:
  - Small footprint — optimized for React Native libraries
  - Built using NitroModules (no bridge)
- ✅ **User Experience**:
  - Safe area-aware
  - Smooth native animations
  - Native feel on both platforms

## 📦 Installation

See [INSTALLATION](./docs/INSTALLATION.md) for full setup instructions.

## 🔧 Quick Start

```tsx
import { showToast } from 'react-native-nitro-toast';

// Basic usage
showToast('Upload completed!');

// Advanced usage
showToast('Upload completed!', {
  type: 'success',
  position: 'top',
  duration: 3000,
  title: 'Success',
  backgroundColor: '#4CAF50',
  messageColor: '#FFFFFF',
  haptics: true
});
```

## 🍱 Presentation Types

- 📚 [Stacked](docs/stacked.md) – Queue-based multiple toast system
- 🔔 Alert – Single toast notification

## 🛠 Configuration Options

| Prop             | Type                         | Default     | Description                                |
|------------------|------------------------------|-------------|--------------------------------------------|
| `type`           | `success`, `error`, `info`, `warning`, `default` | `'default'` | Predefined visual styles                   |
| `title`          | `string`                     | `null`      | Optional title                             |
| `titleColor`     | `string` (HEX)               | Varies by type      | Custom title color (optional)              |
| `message`        | `string`                     | (required)  | Toast message                              |
| `messageColor`   | `string` (HEX)               | Varies by type      | Custom message color (optional)            |
| `duration`       | `number` (MS)                | `4000`      | Auto-dismiss duration                      |
| `position`       | `'top'` \| `'bottom'`        | `'bottom'`  | Toast position                             |
| `presentation`   | `'stacked'` \| `'alert'`     | `'alert'`   | Display style                              |
| `backgroundColor`| `string` (HEX)               | Varies by type | Custom background                       |
| `useOverlay`     | `boolean`                    | `true`      | Apply semi-transparent overlay             |
| `haptics`        | `boolean`                    | `false`     | Enable haptic feedback (iOS & Android, Android requires VIBRATE permission) |

---

## 🧰 Development

Built with modern technologies:

- [NitroModule](https://nitro.margelo.com/) (no JS bridge)
- SwiftUI (iOS 14+)
- Jetpack Compose
- Kotlin + Swift

## 🧩 Roadmap
- [x] Haptic feedback support
- [x] Add gesture support for dismissal
- [x] Auto-dismiss pause on tap
- [ ] Support new Glass effect for iOS
- [ ] Add progress indicator support
- [ ] Add customizable icon support


## 🤝 Contributing

PR welcome

## 💬 Feedback & Issues

Found a bug or have a feature request? Please file an issue at [GitHub Issues](https://github.com/kiethuynh0904/react-native-nitro-toast/issues).

## 👨‍💻 Author

Made with ❤️ by [Kiet Huynh](https://github.com/kiethuynh0904)

## 📝 License

[MIT](./LICENSE)
