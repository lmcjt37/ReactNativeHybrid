import React, { PropTypes } from 'react';
import {
  Button,
  Text,
  View,
} from 'react-native';

import Styles from '../themes/Styles';

const LoginScreen = ({ navigation }) => (
    <View style={ Styles.container }>
        <Text style={ Styles.welcome }>
            Screen A
        </Text>
        <Text style={ Styles.instructions }>
            This is great
        </Text>
        <Button
            onPress={() => navigation.dispatch({ type: 'Login' })}
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
