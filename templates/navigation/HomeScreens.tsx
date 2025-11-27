import React from 'react';
import {View, Text, StyleSheet} from 'react-native';

const styles = StyleSheet.create({
  container: {},
});

interface HomeScreensProps {}

const HomeScreens: React.FC<HomeScreensProps> = props => {
  return (
    <View style={styles.container}>
      <Text>Home</Text>
    </View>
  );
};

export default HomeScreens;
