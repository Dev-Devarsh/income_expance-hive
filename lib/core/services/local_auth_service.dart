import 'package:local_auth/local_auth.dart';
// import 'package:local_auth

class LocalAuth {
  static final _auth = LocalAuthentication();
  static Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      if (await _canAuthenticate()) {
        return await _auth.authenticate(
            localizedReason: 'Please enter password', 
            options: const AuthenticationOptions(
              useErrorDialogs: true, stickyAuth: true,
              //! if you enable [true] then you will not able use pattern lock only biomatric will be enabled
              biometricOnly: false,
            ));
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}