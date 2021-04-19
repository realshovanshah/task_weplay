import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_weplay/services/auth_service.dart';
import 'package:task_weplay/ui/upload/upload_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(
          builder: (BuildContext context) {
            return RaisedButton(
              onPressed: () => {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("Loading... Almost There!"))),
                _authService.signIn(),
              },
              child: Text("Sign In"),
            );
          },
        ),
      ),
    );
  }
}
