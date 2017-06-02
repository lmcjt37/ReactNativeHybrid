import React, { PropTypes, Component } from 'react';
import {
  Button,
  Text,
  View,
  NativeModules,
  NativeEventEmitter
} from 'react-native';

import Styles from '../themes/Styles';
const { AppAuthViewController, Alert, Events } = NativeModules;

class LoginScreen extends Component {
    constructor(props) {
        super(props);
        this.LogEvent;
    }

    static navigationOptions = {
        title: 'Log In',
    };

    componentWillMount() {
        const EventsManagerEmitter = new NativeEventEmitter(Events);
        this.LogEvent = EventsManagerEmitter.addListener(
            'LogEvent',
            (event) => console.log("hello from JS ==> " + JSON.stringify(event))
        );
    }

    componentWillUnmount() {
        this.LogEvent.remove();
    }

    render() {
        const { navigation } = this.props;
        return (
            <View style={ Styles.container }>
                <Text style={ Styles.title }>
                    Login screen
                </Text>
                <Button
                    onPress={() => {
                        AppAuthViewController.authorise((response) => {
                            if (response) {
                                navigation.dispatch({ type: 'Login' });
                            } else {
                                Alert.getAlert("There was a problem logging in.");
                            }
                        });
                    }}
                    title="Log In"
                    />
                <Button
                    onPress={() => {
                        AppAuthViewController.isAuthorised((error, response) => {
                            if (error) {
                                Alert.getAlert(error);
                            }
                            Alert.getAlert("Is the app authorised? " + response);
                        });
                    }}
                    title="Is Authorised?"
                    />
            </View>
        );
    }
}

LoginScreen.propTypes = {
  navigation: PropTypes.object.isRequired,
};

export default LoginScreen;
