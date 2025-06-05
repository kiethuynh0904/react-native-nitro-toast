/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';
import {Button, StyleSheet, View} from 'react-native';
import {showToast} from 'react-native-nitro-toast';

function App(): React.JSX.Element {
  return (
    <>
      <View
        style={{
          flex: 1,
          justifyContent: 'center',
          alignItems: 'center',
          zIndex: 1000,
        }}>
        <Button
          title="Show Toast Stacked"
          onPress={() => {
            showToast('Hello, world!', {
              type: 'default',
              presentation: 'stacked',
            });
          }}
        />

        <Button
          title="Show Toast Alert Info"
          onPress={() => {
            showToast('Hello, world!', {
              type: 'info',
            });
          }}
        />

        <Button
          title="Show Toast Alert Success"
          onPress={() => {
            showToast('Hello, world!', {
              type: 'success',
            });
          }}
        />
        <Button
          title="Show Toast Alert Warning"
          onPress={() => {
            showToast('Hello, world!', {
              type: 'warning',
            });
          }}
        />
        <Button
          title="Show Toast Alert Error"
          onPress={() => {
            showToast('Hello, world!', {
              type: 'error',
              title: 'Custom Title',
              position: 'top',
            });
          }}
        />
      </View>
    </>
  );
}

export default App;
