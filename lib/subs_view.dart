// show list of subs for user
import 'dart:async';

import 'package:flutter/material.dart';
import 'auth/auth_state.dart';
import 'signin_page.dart';
import 'sub_view.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io';

class SubsViewBuilder extends StatelessWidget {

  final StreamController<AuthenticationState> _streamController;
  const SubsViewBuilder(this._streamController);

  Widget buildUi(BuildContext context, AuthenticationState s) {
    if (s.authenticated) {
      return SubsView();
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

class SubsView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  return Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

            RaisedButton(
            child: const Text("Get Subscriptions"),
            splashColor: Colors.blue,
            onPressed: () {
              getsubs('xxx','yyy');
            },
          ),
            RaisedButton(
            child: const Text("Demo Sub"),
            splashColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) 
                => SubPage(title: 'BOT Demo Sub')));
            }
          ),

          ],
          )
        ),
      );
}

  void getsubs(mbid, password) async {
    //get subs from api
    var url = 'https://api.bitcoinofthings.com/getsubs';
      var response = await http.post(
        url,
        body: convert.jsonEncode({"p":mbid, "u":password}),
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        );
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        var data = jsonResponse["data"];
        if (data != null ) {
        var itemCount = data.length;
        print(data);
        print('Number of subscriptions: $itemCount.');
        } else {
          print('Not Authorized!');
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
  }
}