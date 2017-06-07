import React, { PropTypes, Component } from 'react';
import {
  Button,
  Text,
  View,
  NativeModules,
  NativeEventEmitter
} from 'react-native';

import Styles from '../themes/Styles';
const { AppAuthViewController, Alert, EventEmitter } = NativeModules;
const EventManager = new NativeEventEmitter(EventEmitter);

class LoginScreen extends Component {
    constructor(props) {
        super(props);
        this.LogEvent;
        this.LogSuccess;
    }

    static navigationOptions = {
        title: 'Log In',
    };

    componentWillMount() {
        this.LogEvent = EventManager.addListener(
            'LogEvent',
            (event) => console.log(JSON.stringify(event))
        );
    }

    componentWillUnmount() {
        this.LogEvent.remove();
    }

    render() {
        const { navigation } = this.props;
        this.LogSuccess = EventManager.addListener(
            'LogSuccess',
            (response) => {
                if (response.success) {
                    this.LogSuccess.remove();
                    navigation.dispatch({ type: 'Login' });
                } else {
                    Alert.getAlert("There was a problem logging in.");
                }
            }
        );

        return (
            <View style={ Styles.container }>
                <Text style={ Styles.title }>
                    Login screen
                </Text>
                <Button
                    onPress={() => {
                        AppAuthViewController.isAuthorised((response) => {
                            if (response.success) {
                                this.LogSuccess.remove();
                                navigation.dispatch({ type: 'Login' });
                            } else {
                                AppAuthViewController.authorise((response) => console.log(response));
                            }
                        });
                    }}
                    title="Log In"
                    />
            </View>
        );
    }
}

LoginScreen.propTypes = {
  navigation: PropTypes.object.isRequired,
};

export default LoginScreen;
