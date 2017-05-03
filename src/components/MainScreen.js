import React from 'react';
import { View } from 'react-native';

import LoginStatusMessage from './LoginStatusMessage';
import AuthButton from './AuthButton';

import Styles from '../themes/Styles';

const MainScreen = () => (
    <View style={ Styles.container }>
        <LoginStatusMessage />
        <AuthButton />
    </View>
);

MainScreen.navigationOptions = {
  title: 'Home Screen',
};

export default MainScreen;
