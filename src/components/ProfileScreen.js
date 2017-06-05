import React, { PropTypes, Component } from 'react';
import {
  Text,
  View,
  Button
} from 'react-native';

import Styles from '../themes/Styles';

class ProfileScreen extends Component {
    constructor(props) {
        super(props);
    }

    static navigationOptions = {
        title: 'Profile',
    };

    render() {
        return (
            <View style={ Styles.container }>
              <Text style={ Styles.welcome }>
                Profile Screen
              </Text>
            </View>
        );
    }
}

ProfileScreen.propTypes = {
  navigation: PropTypes.object.isRequired,
};

export default ProfileScreen;
