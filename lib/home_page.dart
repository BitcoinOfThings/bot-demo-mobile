// A sample page. Not used
import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:convert';
import 'sub_page.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

            RaisedButton(
            child: const Text("Get Subscriptions"),
            splashColor: Colors.blue,
            onPressed: () {
              //TODO:
            },
          ),
            RaisedButton(
            child: const Text("Demo Sub"),
            splashColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) 
                => SubPage(title: 'BOT Demo Sub')),
              );
            },
          )

          ],
          )
        ),
      ),
    );
  }
}

