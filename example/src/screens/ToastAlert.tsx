import React from 'react';
import {View, Button, StyleSheet} from 'react-native';
import {showToast} from 'react-native-nitro-toast';
import FontAwesome6 from '@react-native-vector-icons/fontawesome6';

const ToastAlert = () => {
  const source = FontAwesome6.getImageSourceSync('solid', 'face-smile', 20, 'white');

  return (
    <View style={styles.container}>
      <Button
        title="Alert - Info"
        onPress={() =>
          showToast('info', {
            title: 'Information',
            type: 'info',
            haptics: true,
          })
        }
      />

      <Button
        title="Alert - Success"
        onPress={() =>
          showToast('success', {
            title: 'Success',
            type: 'success',
            // position: 'top',
            // duration:0,
            haptics: true,
          })
        }
      />

      <Button
        title="Alert - Warning"
        onPress={() =>
          showToast('warning', {
            title: 'Warning',
            type: 'warning',
            haptics: true,
          })
        }
      />

      <Button
        title="Alert - Error"
        onPress={() =>
          showToast('error', {
            title: 'Something went wrong',
            type: 'error',
            haptics: true,
          })
        }
      />

      <Button
        title="Custom"
        onPress={() =>
          showToast('simple text', {
            title: 'Custom Title',
            useOverlay: false,
            backgroundColor: '#4169E1',
            titleColor: '#FFFFFF',
            messageColor: '#FFFFFF',
            haptics: true,
            iconUri: source?.uri,
            position:'top',
          })
        }
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingVertical: 24,
    justifyContent: 'center',
    alignItems: 'center',
    gap: 12,
  },
});

export default ToastAlert;
