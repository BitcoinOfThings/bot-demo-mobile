import 'dart:async';
import 'package:flutter/material.dart';
import 'app_events.dart';
import 'signin_page.dart';
import 'auth/auth_state.dart';

class HomeViewBuilder extends StatelessWidget {

  final StreamController<AuthenticationState> _streamController;
  const HomeViewBuilder(this._streamController);

  Widget buildUi(BuildContext context, AuthenticationState s) {
    if (s.authenticated) {
      return HomeView();
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

  @override
  Widget build(BuildContext context) {
  return Center(
        child: Container(
          child: AppEvents.eventsDisplay()
        )
    );
  }
}


