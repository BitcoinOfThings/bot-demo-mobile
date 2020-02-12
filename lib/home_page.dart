// A sample page. Not used
import 'dart:async';
import 'chat_flow.dart';
import 'helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:upubsub_mobile/app_events.dart';
import 'package:upubsub_mobile/helpers/urllauncher.dart';
import 'auth/auth_state.dart';
import 'chat_view.dart';
import 'components/localStorage.dart';
import 'components/notifications.dart';
//import 'home_view.dart';
import 'main.dart';
import 'subs_view.dart';
import 'pubs_view.dart';
import 'market_view.dart';

// Home page has:
// 1) Button to load Subscriptions
// 2) Show Active subs and choose one
// 3) Show button for Demo sub
// 4) Navigate to sub_page when use selects a sub
class HomePage extends StatefulWidget {
  HomePage({this.title});
  final String title;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  // hold auth state at the home page level, passed to each viewbuilder
  final StreamController<AuthenticationState> _streamController =
      new BehaviorSubject();

  @override
  void dispose() {
    if (_streamController != null) {_streamController.close();}
    super.dispose();
  }

  //signout/logout from app
  signOut() {
    print("SIGNING OUT!");
    LocalStorage.delete(Constants.KEY_USER);
    LocalStorage.delete(Constants.KEY_CHATUSER);
    GlobalNotifier.pause();
    _streamController.add(AuthenticationState.signedOut());
    //clears all routes and directs to sign in screen
    Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: appActions(),
        bottom: TabBar(
          indicatorColor: Colors.amber,
          tabs: <Widget>[
            //Tab(text:'Home', icon: Icon(Icons.home)),
            Tab(text:'Subs', icon: Icon(Icons.subscriptions)),
            Tab(text:'Pubs', icon: Icon(Icons.publish)),
            Tab(text:'Market', icon: Icon(Icons.view_list)),
            Tab(text:'Chat', icon: Icon(Icons.chat))
          ],
        ),
      ),
      body: _body(context, _streamController),
    ),
    );
  }

  List<Widget> appActions () {
    return <Widget>[
      IconButton(
        icon: const Icon(
          Icons.link),
          iconSize: 30,
          tooltip: 'web site',
          onPressed: () {
            UrlLauncher.goHome();
          }),
      IconButton(
        icon: const Icon(
          Icons.notifications),
          iconSize: 30,
          tooltip: 'notification test',
          onPressed: () {
            GlobalNotifier.notifications.show(NotificationMessage('Pub\$Sub sent you a message','Your message could go here'));
            AppEvents.publish('User tested notifications');
          }),
      IconButton(
        icon: const Icon(
          Icons.settings),
          iconSize: 30,
          tooltip: 'settings',
          // route to /applog
          onPressed: () {}),
      IconButton(
        icon: const Icon(
          Icons.exit_to_app),
          iconSize: 30,
          tooltip: 'Logout',
          onPressed: signOut),
    ];
  }

  Widget _body(context, authController) {
    return TabBarView(
      children: <Widget>[
        //new AppLogViewBuilder(authController),
        new SubsViewBuilder(authController),
        new PubsViewBuilder(authController),
        // marketview does not need auth
        new MarketView(),
        new ChatWorkflow(
            child: ChatView()
        )
      ],
      );
  }

}