/**
 * Nitro Toast — example app
 */

import React from 'react'
import { useColorScheme } from 'react-native'
import { createNativeStackNavigator } from '@react-navigation/native-stack'
import {
  createStaticNavigation,
  DefaultTheme,
  DarkTheme,
  type StaticParamList,
} from '@react-navigation/native'
import Home from './src/screens/Home'
import Playground from './src/screens/Playground'
import Showcase from './src/screens/Showcase'

const RootStack = createNativeStackNavigator({
  screenOptions: {
    headerShown: true,
    headerLargeTitle: true,
  },
  screens: {
    Home: {
      screen: Home,
      options: { title: 'Nitro Toast' },
    },
    Playground: Playground,
    Showcase: Showcase,
  },
})

type RootStackParamList = StaticParamList<typeof RootStack>

declare global {
  namespace ReactNavigation {
    interface RootParamList extends RootStackParamList {}
  }
}

const Navigation = createStaticNavigation(RootStack)

function App(): React.JSX.Element {
  const scheme = useColorScheme()
  return <Navigation theme={scheme === 'dark' ? DarkTheme : DefaultTheme} />
}

export default App
