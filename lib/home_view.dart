import 'package:flutter/material.dart';
import 'test_page.dart';

// home view will show login or notifications
Widget homeView(context) {
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
          )

            ]
            )
        )
  );
}
