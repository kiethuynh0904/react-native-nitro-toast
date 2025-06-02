/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';
import {

  Button,
  View,
} from 'react-native';
import { showToast } from 'react-native-nitro-toast';





function App(): React.JSX.Element {


  return (
    <View style={{flex:1, justifyContent: 'center', alignItems: 'center'}}>
      <Button title="Show Toast" onPress={() => {
        showToast('Hello, world!', 'success');
      }} />
    </View>
  );
}



export default App;
