// A sample page
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class TestPage extends StatefulWidget {
  TestPage({this.title});
  final String title;

  @override
  TestPageState createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _body(context),
    );
  }
}

Widget _body(context) {
  return Center(
        child: Container(
          child: RaisedButton(
            child: const Text("A test page"),
            splashColor: Colors.blue,
            onPressed: () {
              _getTime(context);
            },
          ),
        ),
      );
}

printString() async {
  // With await, we are assured of getting a string back and not a
  // Future<String> placeholder instance.
  // The rest of the code in the Main UI thread can continue.  When
  // the returnAString() function completes, it will go ahead.
  // I liked the explanation in the "Dart & Flutter Asnchronous Tutorial.."
  // https://bit.ly/2Dq12PJ
  String returnString = await returnAString();
  print('the string is --> $returnString');
}

Future<String> returnAString() {
  // (in the future...) after 6 seconds, the string 'hello there' will
  // be in the result var until then it is an "Instance of Future<String>"
  Future<String> result = Future.delayed(Duration(seconds: 5), () {
    return 'hello there';
  });
  return result;
}

Future<Map> _getBrokerAndKey(BuildContext context) async {
  String connect =
      await DefaultAssetBundle.of(context).loadString("config/private.json");
  return (json.decode(connect));
}

_getTime(BuildContext context) async {
  print("right before getConnectStuff");
  Map connectJson = await _getBrokerAndKey(context);
  print('broker: ${connectJson['broker']}');
  print('key   : ${connectJson['key']}');

  print("right after getConnectStuff");
  printString();
}
