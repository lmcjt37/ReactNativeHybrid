import React, { PropTypes, Component } from 'react';
import { View } from 'react-native';

import LoginStatusMessage from './LoginStatusMessage';
import AuthButton from './AuthButton';

import Styles from '../themes/Styles';

class MainScreen extends Component {
    constructor(props) {
        super(props);
    }

    static navigationOptions = {
        title: 'Home Screen',
    };

    render() {
        return (
            <View style={ Styles.container }>
                <LoginStatusMessage />
                <AuthButton />
            </View>
        );
    }
}

MainScreen.propTypes = {
  navigation: PropTypes.object.isRequired,
};

export default MainScreen;
