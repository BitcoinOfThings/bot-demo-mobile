import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'signin_page.dart';
import 'test_page.dart';
import 'auth/auth_state.dart';

class HomeViewBuilder extends StatelessWidget {

  final StreamController<AuthenticationState> _streamController;
  const HomeViewBuilder(this._streamController);

  Widget buildUi(BuildContext context, AuthenticationState s) {
    if (s.authenticated) {
      return HomeView(_streamController);
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

// home view will show login or notifications
class HomeView extends StatelessWidget {
  final StreamController<AuthenticationState> _streamController;
  
  const HomeView(this._streamController);

  signOut() {
    _streamController.add(AuthenticationState.signedOut());
  }

  @override
  Widget build(BuildContext context) {
  return Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            RaisedButton(
            child: const Text("Test"),
            splashColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) 
                => TestPage(title: 'Test Notification')),
              );
            },
          ),
          RaisedButton(
          child: Text('Sign Out'),
          onPressed: signOut,
        ),

            ]
            )
        )
    );
  }
}
