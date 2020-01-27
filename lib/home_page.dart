// A sample page. Not used
import 'package:flutter/material.dart';
// import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io';
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

  void getsubs(mbid, password) async {
    //get subs from api
    var url = 'https://api.bitcoinofthings.com/getsubs';
      // Await the http get response, then decode the json-formatted response.
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
