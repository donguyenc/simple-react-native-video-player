import {   requireNativeComponent } from 'react-native'
import React, { useState } from 'react';
import {
  Text,
  StatusBar,
  View,
  StyleSheet
} from 'react-native';
import FontAwesome from '@expo/vector-icons/FontAwesome';
import {Slider} from '@miblanchard/react-native-slider';
import {NativeModules} from 'react-native';
import moment from 'moment';
const VideoPlayer = requireNativeComponent("VideoPlayer")
const {VideoPlayerManager} = NativeModules;

const CustomVideoPlayer = ({url}) => {
  const [currentDuration, setCurrentDuration] = useState(0)
  const [currentTime, setCurrentTime] = useState(0)

  const durationFormatted = moment.utc(currentDuration*1000).format('mm:ss')
  const currentTimeFormatted = moment.utc(currentTime*1000).format('mm:ss')

  const pause = () => {
    VideoPlayerManager.pause()
  }

  const play = () => {
    VideoPlayerManager.play()
  }

  const onLoaded = (e) => {
    setCurrentDuration(e.nativeEvent.durationInSeconds)
  }

  const timeObserver = e => {
    setCurrentTime(e.nativeEvent.durationInSeconds)
  }

  const onSlidingStart = e => {
    VideoPlayerManager.pause()
  }

  const onSlidingComplete = e => {
    VideoPlayerManager.play()
  }

  const onSliding = changingValue => {
    VideoPlayerManager.seek(changingValue * currentDuration)
  }

  return (
    <View style={{ flex: 1 }}>
      <VideoPlayer 
        videoUrl={url}
        style={styles.wrapper}
        onLoaded={onLoaded}
        onCurrentTimeChange={timeObserver}
      />
      <View style={styles.controls}>
        <Slider
          value={(currentTime/currentDuration)}
          onValueChange={onSliding}
          onSlidingStart={onSlidingStart}
          onSlidingComplete={onSlidingComplete}
        />
        <Text>{currentTimeFormatted}/{durationFormatted}</Text>
        <View style={styles.spacer} />
        {/* For desmonstation we have 2 buttons. should be 1 */}
        <FontAwesome.Button name="play" onPress={play}>
          Play
        </FontAwesome.Button>
        <View style={styles.spacer} />
        <FontAwesome.Button backgroundColor={'red'} name="pause" onPress={pause}>
          Pause
        </FontAwesome.Button>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  wrapper: {
    height: 300
  },
  controls: {
    paddingHorizontal: 20,
  },
  button: {
    backgroundColor: 'red',
    marginBottom: 12
  },
  spacer: {
    height: 12
  }
});

export default CustomVideoPlayer