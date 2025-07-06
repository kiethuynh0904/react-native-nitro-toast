import React from 'react';
import {View, Button, StyleSheet} from 'react-native';
import {
  showToast,
  showToastPromise,
} from 'react-native-nitro-toast';
import FontAwesome6 from '@react-native-vector-icons/fontawesome6';

const ToastAlert = () => {
  const source = FontAwesome6.getImageSourceSync(
    'solid',
    'face-smile',
    20,
    'white',
  );

  // Fake API function
  const fakeUploadAPI = (): Promise<{message: string}> => {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        // Randomly throw an error to simulate failure
        if (Math.random() < 0.4) {
          reject(new Error('Simulated upload failure'));
        } else {
          resolve({
            message: 'Your file has been uploaded successfully!',
          });
        }
      }, 2000);
    });
  };

  const showLoadingToast = async () => {
    await showToastPromise(
      fakeUploadAPI(),
      {
        loading: 'Your file is being uploaded...',
        success: result => result.message,
        error: error =>
          error instanceof Error
            ? error.message
            : 'Upload failed. Please try again.',
      },
      {
        position: 'top',
        haptics: true,
        loading: {
          title: 'Uploading',         
        },
      },
    );
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
