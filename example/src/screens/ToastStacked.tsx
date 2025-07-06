import React from 'react';
import {View, StyleSheet, Button, Text} from 'react-native';
import {showToast} from 'react-native-nitro-toast';

const ToastStacked = () => {
  return (
    <View style={styles.container}>
      <Text style={styles.description}>
        This screen demonstrates stacked toasts. Tap a button to show a toast of the corresponding type.
      </Text>
      <Button
        title="Show Success Toast"
        color="#22C55E"
        onPress={() => {
          showToast('Operation successful! Operation successful! Operation successful!', {
            type: 'success',
            presentation: 'stacked',
            duration: 0,
          });
        }}
      />
      <Button
        title="Show Error Toast"
        color="#EF4444"
        onPress={() => {
          showToast('Something went wrong.', {
            type: 'error',
            presentation: 'stacked',
            duration: 0,
          });
        }}
      />
      <Button
        title="Show Warning Toast"
        color="#F59E0B"
        onPress={() => {
          showToast('This is a warning.', {
            type: 'warning',
            presentation: 'stacked',
            duration: 0,
          });
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
  description: {
    fontSize: 16,
    marginBottom: 16,
    textAlign: 'center',
    color: '#333',
  },
});

export default ToastStacked;
