/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createStaticNavigation, type StaticParamList } from '@react-navigation/native';
import ToastAlert from './src/screens/ToastAlert';
import ToastStacked from './src/screens/ToastStacked';
import Home from './src/screens/Home';

const RootStack = createNativeStackNavigator({
  screens: {
    Home: Home,
    ToastAlert: ToastAlert,
    ToastStacked: ToastStacked,
  },
});

type RootStackParamList = StaticParamList<typeof RootStack>;

declare global {
  namespace ReactNavigation {
    interface RootParamList extends RootStackParamList {}
  }
}

const Navigation = createStaticNavigation(RootStack);

function App(): React.JSX.Element {
  return <Navigation />;
}

export default App;
