# 🍞 Stacked Toast (iOS Only)

> ⚠️ Currently supported only on iOS.

The `stacked` presentation queues multiple toasts and displays them one-by-one.

---

## 🔧 Usage

```tsx
import { showToast } from 'react-native-nitro-toast';

showToast('First toast', {
  presentation: 'stacked',
});
