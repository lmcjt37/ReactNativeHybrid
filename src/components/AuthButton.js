import React, { PropTypes, Component } from 'react';
import { connect } from 'react-redux';
import {
    Button,
    NativeModules
} from 'react-native';
import { NavigationActions } from 'react-navigation';

const { AppAuthViewController } = NativeModules;

class AuthButton extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        const { logout, login, isLoggedIn } = this.props;
        return (
            <Button
              title={ isLoggedIn ? 'Log Out' : 'Log In' }
              onPress={ isLoggedIn ? logout : login }
            />
        )
    }
}

AuthButton.propTypes = {
  isLoggedIn: PropTypes.bool.isRequired,
  logout: PropTypes.func.isRequired,
  login: PropTypes.func.isRequired,
};

const mapStateToProps = state => ({
  isLoggedIn: state.auth.isLoggedIn,
});

const mapDispatchToProps = dispatch => ({
  logout: () => {
      AppAuthViewController.logout((response) => {
          if (response) {
              dispatch({ type: 'Logout' })
          }
      });
  },
  login: () => dispatch(NavigationActions.navigate({ routeName: 'Login' })),
});

export default connect(mapStateToProps, mapDispatchToProps)(AuthButton);
