import React from 'react';
import {View, Button, StyleSheet} from 'react-native';
import {showToast} from 'react-native-nitro-toast';

const ToastAlert = () => {
  return (
    <View style={styles.container}>

      <Button
        title="Alert - Info"
        onPress={() =>
          showToast('info', {
            title: 'Information',
            type: 'info',
            position: 'top',
            haptics:true,
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
            haptics:true,
          })
        }
      />

      <Button
        title="Alert - Warning"
        onPress={() =>
          showToast('warning', {
            title: 'Warning',
            type: 'warning',
            position: 'top',
            haptics:true,
          })
        }
      />

      <Button
        title="Alert - Error"
        onPress={() =>
          showToast('error', {
            title: 'Something went wrong',
            type: 'error',
            position: 'top',
            haptics:true,
          })
        }
      />

      <Button
        title="Custom"
        onPress={() =>
          showToast('simple text', {
            title: 'Custom Title',
            position: 'top',
            useOverlay: false,
            backgroundColor: '#4169E1',
            titleColor: '#FFFFFF',
            messageColor: '#FFFFFF',
            haptics:true,
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
