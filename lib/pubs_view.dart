// to show list of publications user has created
import 'dart:async';
import 'package:flutter/material.dart';
import 'auth/auth_state.dart';
import 'signin_page.dart';

class PubsViewBuilder extends StatelessWidget {

  final StreamController<AuthenticationState> _streamController;
  const PubsViewBuilder(this._streamController);

  Widget buildUi(BuildContext context, AuthenticationState s) {
    if (s.authenticated) {
      return PubsView();
    } else {
      return SignInPage(_streamController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<AuthenticationState>(
        stream: _streamController.stream,
        initialData: new AuthenticationState.initial(),
        builder: (BuildContext context,
            AsyncSnapshot<AuthenticationState> snapshot) {
          final state = snapshot.data;
          return buildUi(context, state);
        });
  }
}

class PubsView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  return Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('User Pubs will go here')
            ]
            )
        )
  );
}
}
