import 'package:complemento/home.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:firebase_ui_auth/firebase_ui_auth.dart'
    show AuthAction, EmailAuthProvider, SignInScreen;
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
              providers: [
                EmailAuthProvider(),
                GoogleProvider(
                    clientId:
                        "659817751867-9bhma3615u7d4qm4b6vqaahongu9fsgh.apps.googleusercontent.com")
              ],
              headerBuilder: (context, contraints, shrinkOffset) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image(image: AssetImage('images/logo-ic.png')),
                  ),
                );
              },
              subtitleBuilder: (context, action) {
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: action == AuthAction.signIn
                        ? Text('Welcome to Complemento! Please sign in!')
                        : Text('Welcome to Complemento! Please sign up!'));
              },
              footerBuilder: (context, action) => Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              sideBuilder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset('images/logo-ic.png'),
                  ),
                );
              },
            );
          }
          return MyHomePage(
            title: 'Trilha Complementar',
          );
        });
  }
}
