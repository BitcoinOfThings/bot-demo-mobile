import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'auth/auth_state.dart';

class SignInPage extends StatelessWidget {
  final StreamController<AuthenticationState> _streamController;

  SignInPage(this._streamController);

  signIn() async {
    _streamController.add(AuthenticationState.authenticated());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign in')),
      body: Center(
        child: RaisedButton(
          child: Text('TODO: Login form goes here'),
          onPressed: signIn,
        ),
      ),
    );
  }
}