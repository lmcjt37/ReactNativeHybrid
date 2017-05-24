import React, { PropTypes } from 'react';
import {
  Button,
  Text,
  View,
  NativeModules
} from 'react-native';

import Styles from '../themes/Styles';

const LoginScreen = ({ navigation }) => (
    <View style={ Styles.container }>
        <Text style={ Styles.title }>
            Login screen
        </Text>
        <Button
            onPress={() => {
                NativeModules.CustomAppAuth.authorise((response) => {
                    console.log(response);
                });
            }}
            title="Authorise"
            />
        <Button
            onPress={() => {
                NativeModules.CustomAppAuth.signin((response) => {
                    console.log(response);
                    navigation.dispatch({ type: 'Login' });
                });
            }}
            title="Log in"
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
