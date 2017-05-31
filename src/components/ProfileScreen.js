import React from 'react';
import {
  Text,
  View,
  Button
} from 'react-native';

import Styles from '../themes/Styles';

const ProfileScreen = () => (
  <View style={ Styles.container }>
    <Text style={ Styles.welcome }>
      Profile Screen
    </Text>
  </View>
);

ProfileScreen.navigationOptions = {
  title: 'Profile',
};

export default ProfileScreen;
