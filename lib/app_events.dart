
// a feed for application events
// will be used for significant events
// like login/logout
// subscription start/stop
// purchases
// error messages
// anything user might be interested in 
// or for debugging
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// could be stream and ui widgets?
// this will need to change to a stateful widget
class AppEvents {
  static List<String> _events = new List<String>();
  static StreamController<String> _eventsController = 
    BehaviorSubject();

  static BehaviorSubject<String> get stream => 
    _eventsController.stream;

  static void close() {
    _eventsController.close();
  }

  static void publish(String message) {
    //_eventsController.add(message);
    _events.add(message);
  }

          // new StreamBuilder<String>(
          //   stream: _eventsController.stream,
          //   initialData: "Application events will show here",
          //   builder: (BuildContext context,
          //       AsyncSnapshot<String> snapshot) {
          //     final state = snapshot.data;
          //     return Text(state);
          // });

static buildItem(context, index) {
  return new Text(_events[index]);
}

  static Widget eventsDisplay() {
    return Container(
      margin: EdgeInsets.all(20),
      child:

      Column(
      children: <Widget>[
        Flexible(
        child: new ListView.builder(
          shrinkWrap: true,
          itemCount: _events.length,
          itemBuilder: ( context, index ) =>
            buildItem(context, index)
          ,)
        )
      ]
      )
    )
  ;}

}