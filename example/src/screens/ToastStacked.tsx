import React from 'react';
import {View, StyleSheet, Button} from 'react-native';
import {showToast} from 'react-native-nitro-toast';

const ToastStacked = () => {
  return (
    <View style={styles.container}>
      <Button
        title="Show Toast Stacked"
        onPress={() => {
          showToast('Hello, world!', {
            type: 'default',
            presentation: 'stacked',
            duration:0,
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
});

export default ToastStacked;
