# 🚀 react-native-nitro-toast

A lightweight, native-powered toast notification library for React Native, built with SwiftUI (iOS) and Jetpack Compose (Android). Fast, flexible, and customizable.

---

## ✨ Features

- ✅ Fully native: SwiftUI (iOS) & Jetpack Compose (Android)
- ✅ Multiple styles: `stacked`, `alert`, and `custom`
- ✅ Supports `success`, `error`, `info`, `warning`, or custom types
- ✅ Auto-dismiss with configurable duration
- ✅ Show at `top` or `bottom`
- ✅ Small footprint — optimized for React Native libraries
- ✅ Safe area-aware
- ✅ Optional background opacity control
- ⚡ Built using TurboModules (no bridge)

---

## 📦 Installation

```bash
npm install react-native-nitro-toast
# or
yarn add react-native-nitro-toast
```

---

## 🔧 Usage

### Show a simple toast:

```tsx
import { showToast } from 'react-native-nitro-toast';

showToast('Upload completed!', {
  type: 'success',
  position: 'top',
  duration: 3000
});
```

---

## 🛠 Config Options

| Prop             | Type                         | Default     | Description                                |
|------------------|------------------------------|-------------|--------------------------------------------|
| `type`           | `success`, `error`, `info`, `warning`, `default` | `'default'` | Predefined visual styles                   |
| `title`          | `string`                     | `null`      | Optional title                             |
| `titleColor`     | `string` (HEX)               | Varies by type      | Custom title color (optional)              |
| `message`        | `string`                     | (required)  | Toast message                              |
| `messageColor`   | `string` (HEX)               | Varies by type      | Custom message color (optional)            |
| `duration`       | `number` (MS)                | `3000`      | Auto-dismiss duration                      |
| `position`       | `'top'` \| `'bottom'`        | `'bottom'`  | Toast position                             |
| `presentation`   | `'stacked'` \| `'alert'`     | `'alert'`   | Display style                              |
| `backgroundColor`| `string` (HEX)               | Varies by type | Custom background                       |                      |
| `useOverlay`     | `boolean`                    | `true`      | Apply semi-transparent overlay             |

---

## 📱 Platform Support

| Platform | Status     |
|----------|------------|
| iOS      | ✅ SwiftUI |
| Android  | ✅ Compose |

---

## 🧰 Development

Built with:

- [NitroModule](https://nitro.margelo.com/) (no JS bridge) 
- SwiftUI (iOS 14+)
- Jetpack Compose
- Kotlin + Swift

---

## 🧩 Roadmap

- [ ] Custom templates
- [ ] Accessibility improvements
- [ ] Add progress indicator support
- [ ] RTL support

---

## 💬 Feedback / Issues

Please file issues or feature requests at [GitHub Issues](https://github.com/kiethuynh0904/react-native-nitro-toast/issues).

PRs welcome 🚀

---

## 👨‍💻 Author

Made with ❤️ by Kiet Huynh

---

## 📝 License

[MIT](./LICENSE)