import 'package:diplomski/services/auth/auth_provider.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class LocalAutApi implements AuthProvider {
  final LocalAuthentication auth = LocalAuthentication();

  final String _message = "Not Authorized";

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
          localizedReason: "Verification required to use the app",
          options: const AuthenticationOptions(useErrorDialogs: true));
    } on PlatformException catch (e) {
      print(e.code);
      if (e.code == auth_error.notEnrolled) {
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
      } else {}
    }
  }

  @override
  Future<void> initialize() {
    throw UnimplementedError();
  }
}
