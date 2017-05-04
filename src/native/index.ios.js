import { NativeModules } from 'react-native';

export const getAlertFromNative = (text) => {
    NativeModules.Alert.getAlert(text);
}
