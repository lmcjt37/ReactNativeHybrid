import React, { PropTypes } from 'react';
import {
  Button,
  Text,
  View,
  NativeModules
} from 'react-native';

import Styles from '../themes/Styles';
const { AppAuthViewController, Alert } = NativeModules;

const LoginScreen = ({ navigation }) => (
    <View style={ Styles.container }>
        <Text style={ Styles.title }>
            Login screen
        </Text>
        <Button
            onPress={() => {
                AppAuthViewController.authorise((response) => {
                    if (response) {
                        navigation.dispatch({ type: 'Login' });
                        Alert.getAlert(JSON.stringify(response, null, 4));
                    } else {
                        Alert.getAlert("There was a problem logging in.");
                    }
                });
            }}
            title="Log In"
            />
    </View>
);

LoginScreen.propTypes = {
  navigation: PropTypes.object.isRequired,
};

LoginScreen.navigationOptions = {
  title: 'Log In',
};

export default LoginScreen;
