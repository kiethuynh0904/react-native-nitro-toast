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

      // Randomly throw an error to simulate failure
      if (Math.random() < 0.5) {
        throw new Error('Simulated upload failure');
      }

      showToast('Your file has been uploaded successfully!', {
        toastId: id,
        type: 'success',
        haptics: true,
        position: 'top',
      });
    } catch (error) {
      // You can customize the error message here
      showToast(
        error instanceof Error
          ? error.message
          : 'Upload failed. Please try again.',
        {
          toastId: id,
          haptics: true,
          type: 'error',
          position: 'top',
        }
      );
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
        onPress={() => {
          const config: any = {
            title: 'Custom Style',
            useOverlay: false,
            backgroundColor: '#4169E1',
            titleColor: '#FFFFFF',
            messageColor: '#FFFFFF',
            haptics: true,
            position: 'top',
          };
          
          if (source?.uri) {
            config.iconUri = source.uri;
          }
          
          showToast('This is a custom styled toast message', config);
        }}
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
