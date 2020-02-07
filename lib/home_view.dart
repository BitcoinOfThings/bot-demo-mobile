import 'dart:async';
import 'package:flutter/material.dart';
import 'app_events.dart';
// import 'signin_page.dart';
import 'auth/auth_state.dart';

class AppLogViewBuilder extends StatelessWidget {

  final StreamController<AuthenticationState> _streamController;
  const AppLogViewBuilder(this._streamController);

  Widget buildUi(BuildContext context, AuthenticationState s) {
    // if (s.authenticated) {
      return AppLogView();
    // } else {
    //   return SignInPage(_streamController);
    // }
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

// applog will show log of application events
// could be a dashboard?
class AppLogView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  return Center(
        child: Container(
          child: AppEvents.eventsDisplay()
        )
    );
  }
}


