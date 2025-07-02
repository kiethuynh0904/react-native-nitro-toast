# 🍞 Stacked Toast (iOS Only)

> ⚠️ Currently supported only on iOS.

https://github.com/user-attachments/assets/1a11797d-e3a9-409f-8f10-c81c8edf8677


The `stacked` presentation queues multiple toasts and displays them one-by-one.

---

## 🔧 Usage

```tsx
import { showToast } from 'react-native-nitro-toast';

showToast('First toast', {
  presentation: 'stacked',
  type: 'success',
  duration: 0,
});
