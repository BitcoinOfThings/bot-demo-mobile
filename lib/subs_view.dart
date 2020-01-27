// show list of subs for user
import 'package:flutter/material.dart';
import 'sub_view.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io';

Widget subsView(context) {
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
