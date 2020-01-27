// A sample page. Not used
import 'package:flutter/material.dart';
import 'home_view.dart';
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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:4,
      child: Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          tabs: <Widget>[
            Text('Home'),
            Text('Subs'),
            Text('Pubs'),
            Text('Market')
          ],
        ),
      ),
      body: _body(context),
    ),
    );
  }
}

Widget _body(context) {
  return TabBarView(
    children: <Widget>[
      homeView(context),
      subsView(context),
      pubsView(context),
      //marketView(context)
      new MarketView()
    ],
    );
}
