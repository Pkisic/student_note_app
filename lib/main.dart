import 'package:diplomski/services/auth/biometric_auth_provider.dart';
import 'package:diplomski/services/auth/bloc/auth_bloc.dart';
import 'package:diplomski/services/auth/bloc/auth_event.dart';
import 'package:diplomski/services/auth/bloc/auth_state.dart';
import 'package:diplomski/views/notes_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Aplikacija za unos beleski',
    home: BlocProvider<AuthBlock>(
      create: (context) => AuthBlock(LocalAutApi()),
      child: const HomePage(),
    ),
    routes: const {},
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBlock>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBlock, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is AuthStateNeedsVerification) {
          return const NotesView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
