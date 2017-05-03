/**
 * @flow
 */

import React, { Component } from 'react';
import { AppRegistry } from 'react-native';
import { Provider } from 'react-redux';
import { createStore } from 'redux';

import AppReducer from './src/reducers';
import AppWithNavigationState from './src/navigators/AppNavigator';

export default class ReactNavigationSample extends Component {
    store = createStore(AppReducer);

    render() {
        return (
            <Provider store={ this.store }>
                <AppWithNavigationState />
            </Provider>
        );
    }
}

AppRegistry.registerComponent('ReactNavigationSample', () => ReactNavigationSample);
