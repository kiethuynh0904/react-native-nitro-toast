import React from 'react';
import {View, Button, StyleSheet} from 'react-native';
import {dismissToast, showToast} from 'react-native-nitro-toast';
import FontAwesome6 from '@react-native-vector-icons/fontawesome6';

const ToastAlert = () => {
  const source = FontAwesome6.getImageSourceSync(
    'solid',
    'face-smile',
    20,
    'white',
  );

  const showLoadingToast = async () => {
    const id = showToast('Please wait...', {
      type: 'loading',
      title: 'Uploading',
      duration: 0,
      position: 'top',
    });

    try {
      // Simulate async upload operation
      await new Promise(resolve => setTimeout(resolve, 2000));
      dismissToast(id);
      showToast('Your file has been uploaded', {
        type: 'success',
        position: 'top',
      });
    } catch (error) {
      dismissToast(id);
      showToast('Upload failed. Please try again.', {
        type: 'error',
        position: 'top',
      });
    }
  };

  return (
    <View style={styles.container}>
      <Button
        title="Show Info Toast"
        onPress={() =>
          showToast('This is an informational message', {
            title: 'Information',
            type: 'info',
            position: 'top',
            haptics: true,
          })
        }
      />

      <Button
        title="Show Success Toast"
        onPress={() =>
          showToast('Operation completed successfully!', {
            title: 'Success',
            type: 'success',
            position: 'top',
            haptics: true,
          })
        }
      />

      <Button
        title="Show Warning Toast"
        onPress={() =>
          showToast('Please check your input before proceeding', {
            title: 'Warning',
            type: 'warning',
            position: 'top',
            haptics: true,
          })
        }
      />

      <Button
        title="Show Error Toast"
        onPress={() =>
          showToast('An unexpected error occurred', {
            title: 'Error',
            type: 'error',
            position: 'top',
            haptics: true,
          })
        }
      />
      <Button title="Simulate File Upload" onPress={showLoadingToast} />

      <Button
        title="Show Custom Toast"
        onPress={() =>
          showToast('This is a custom styled toast message', {
            title: 'Custom Style',
            useOverlay: false,
            backgroundColor: '#4169E1',
            titleColor: '#FFFFFF',
            messageColor: '#FFFFFF',
            haptics: true,
            iconUri: source?.uri,
            position: 'top',
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
