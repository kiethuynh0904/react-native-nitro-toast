/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, { useState } from 'react';
import {Button, View} from 'react-native';
import {showToast} from 'react-native-nitro-toast';

function App(): React.JSX.Element {
  const [index, setIndex] = useState(0);

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
            showToast(`Hello, world! ${index}`, {
              type: 'success',
              backgroundColor:'#4169E1',
            });
            setIndex(index + 1);
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
