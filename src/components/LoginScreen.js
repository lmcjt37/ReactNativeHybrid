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
    }

    static navigationOptions = {
        title: 'Log In',
    };

    componentDidMount() {
        const EventsManagerEmitter = new NativeEventEmitter(Events);
        const LogEvent = EventsManagerEmitter.addListener(
            'LogEvent',
            (event) => console.log(event.log)
        );
        const LogSuccess = EventsManagerEmitter.addListener(
            'LogSuccess',
            (response) => Alert.getAlert(JSON.stringify(response, null, 4))
        );
    }

    componentWillUnmount() {
        LogEvent.remove();
        LogSuccess.remove();
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
            </View>
        );
    }
}

// const LoginScreen = ({ navigation }) => (
//     <View style={ Styles.container }>
//         <Text style={ Styles.title }>
//             Login screen
//         </Text>
//         <Button
//             onPress={() => {
//                 AppAuthViewController.authorise((response) => {
//                     if (response) {
//                         navigation.dispatch({ type: 'Login' });
//                         Alert.getAlert(JSON.stringify(response, null, 4));
//                     } else {
//                         Alert.getAlert("There was a problem logging in.");
//                     }
//                 });
//             }}
//             title="Log In"
//             />
//     </View>
// );

LoginScreen.propTypes = {
  navigation: PropTypes.object.isRequired,
};

// LoginScreen.navigationOptions = {
//   title: 'Log In',
// };

export default LoginScreen;
