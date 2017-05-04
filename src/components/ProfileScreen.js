import React from 'react';
import {
  Text,
  View,
  Button
} from 'react-native';

import Styles from '../themes/Styles';
import { getAlertFromNative } from '../native/index';

const ProfileScreen = () => (
  <View style={ Styles.container }>
    <Text style={ Styles.welcome }>
      Profile Screen
    </Text>
    <Button
      title="Native Alert 1"
      onPress={ () => getAlertFromNative("This is my first example.") }
    />
    <Button
      title="Native Alert 2"
      onPress={ () => getAlertFromNative("This is my second example.") }
    />
  </View>
);

ProfileScreen.navigationOptions = {
  title: 'Profile',
};

export default ProfileScreen;
