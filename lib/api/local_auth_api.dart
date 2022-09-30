import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class LocalAutApi {
  final LocalAuthentication auth = LocalAuthentication();

  String _message = "Not Authorized";

  Future<List<BiometricType>> checkingForBioMetrics() async {
    List<BiometricType> canCheck = await auth.getAvailableBiometrics();
    bool c = await auth.isDeviceSupported();
    print(canCheck);
    print(c);
    return canCheck;
  }

  Future<void> authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: "localizedReason",
          options: const AuthenticationOptions(useErrorDialogs: true));
    } on PlatformException catch (e) {
      print(e.code);
      if (e.code == auth_error.notEnrolled) {
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
      } else {}
    }
  }
}
