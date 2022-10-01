import 'package:bloc/bloc.dart';
import 'package:diplomski/services/auth/auth_provider.dart';
import 'package:diplomski/services/auth/bloc/auth_event.dart';
import 'package:diplomski/services/auth/bloc/auth_state.dart';

class AuthBlock extends Bloc<AuthEvent, AuthState> {
  AuthBlock(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    //biometric verification
    on<AuthEventVerify>((event, emit) async {
      emit(const AuthStateNeedsVerification(isLoading: false));
    });

    on<AuthEventInitialize>((event, emit) async {
      emit(const AuthStateNeedsVerification(isLoading: false));
    });
  }
}
