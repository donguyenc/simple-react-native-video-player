import React, { useState } from 'react';
import {
  Text,
  StatusBar,
  View,
  StyleSheet
} from 'react-native';
import MyVideoPlayer from './components/VideoPlayer'

const App = () => {
  const videoURL =
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
  
  return (
    <View style={styles.container}>
      <StatusBar barStyle="dark-content" backgroundColor={'#e4e5ea'} />
      <Text style={styles.title}>Video Player</Text>
      <MyVideoPlayer url={videoURL} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#e4e5ea',
    flex: 1,
    paddingTop: 50,
    alignItems: "stretch",
  },
  title: {
    fontSize: 20,
    color: '#000',
    marginVertical: 25,
    alignSelf: 'center',
    justifyContent: 'center',
    textAlign: 'center'
  }
});

export default App;