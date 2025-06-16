import React from 'react';
import {Button, View, StyleSheet} from 'react-native';
import {useNavigation} from '@react-navigation/native';

const Home = () => {
  const navigation = useNavigation();

  return (
    <View style={styles.container}>
      <View style={styles.buttonContainer}>
        <Button
          title="Go to Toast Alert"
          onPress={() => navigation.navigate('ToastAlert')}
        />
      </View>
      <View style={styles.buttonContainer}>
        <Button
          title="Go to Toast Stacked"
          onPress={() => navigation.navigate('ToastStacked')}
        />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 16,
  },
  buttonContainer: {
    marginVertical: 8,
    width: '100%',
    maxWidth: 300,
  },
});

export default Home;
