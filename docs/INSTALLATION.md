# 📦 Installation

1. **Install peer dependencies:**

This library requires [`react-native-nitro-modules`](https://www.npmjs.com/package/react-native-nitro-modules) as a peer dependency. You must install it in your project:

```sh
yarn add react-native-nitro-modules
```

2. **Install this package:**

```sh
yarn add react-native-nitro-toast
```

3. **Install iOS dependencies:**

```sh
cd ios && pod install && cd ..
```

4. **(Optional) Enable haptics on Android:**

If you want to use haptic feedback on Android, add the following permission to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.VIBRATE" />
```

5. **Continue with the [Quick Start](../README.md#-quick-start) in the main README.** 