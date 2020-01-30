// This will be the subscription page
// in context of on subscription, show that sub messages
import 'package:bot_demo_mobile/main.dart';
import 'package:flutter/material.dart';
import 'components/notifications.dart';
import 'mqtt_stream.dart';
import 'BitcoinOfThings_feed.dart';

class SubPage extends StatefulWidget {
  SubPage({this.title});
  final String title;

  @override
  MqttPageState createState() => MqttPageState();
}

class MqttPageState extends State<SubPage> {
  // Handles connecting, subscribing, publishing to BitcoinOfThings
  PubSubConnection pubsub = PubSubConnection(null);
  //Notifications _notifications;

  final myTopicController = TextEditingController(text:'demo');
  final myValueController = TextEditingController();

  MqttPageState () {
    // this._notifications = new Notifications();
    // this._notifications.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _body(),
    );
  }

  //
  // The body of the page.  The children contain the main components of
  // the UI.
  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _subscriptionInfo(),
        _subscriptionData(),
        _publishInfo(),
      ],
    );
  }

//
// The UI to get and subscribe to the mqtt topic.
//
  Widget _subscriptionInfo() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Topic:',
                style: TextStyle(fontSize: 24),
              ),
              // To use TextField within a row, it needs to be wrapped in a Flexible
              // widget.  See Stackoverflow: https://bit.ly/2IkzqBk
              Flexible(
                child: TextField(
                  controller: myTopicController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter topic to subscribe to',
                  ),
                ),
              ),
            ],
          ),
          RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('Subscribe'),
            onPressed: () {
              subscribe(myTopicController.text);
            },
          ),
        ],
      ),
    );
  }

  Widget _subscriptionData() {
    return StreamBuilder(
        stream: BitcoinOfThingsMux.stream,
        builder: (context, snapshot) {
          // if (!snapshot.hasData) {
          //   return CircularProgressIndicator();
          // }
          String reading = snapshot.data;
          if (reading == null) {
            reading = 'Messages show here when received.';
          }
          GlobalNotifier.notifications.show(NotificationMessage(
            'test',reading
          ));
          return Text(reading);
        });
  }

  Widget _publishInfo() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Message:',
                style: TextStyle(fontSize: 24),
              ),
              // To use TextField within a row, it needs to be wrapped in a Flexible
              // widget.  See Stackoverflow: https://bit.ly/2IkzqBk
              Flexible(
                child: TextField(
                  controller: myValueController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter message to publish',
                  ),
                ),
              ),
            ],
          ),
          RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('Publish'),
            onPressed: () {
              publish(myTopicController.text, myValueController.text);
            },
          ),
        ],
      ),
    );
  }

  void subscribe(String topic) {
    pubsub.subscribe(topic);
  }

  void publish(String topic, String value) {
    pubsub.publish(topic, value);
  }
}
