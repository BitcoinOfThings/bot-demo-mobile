// base class for pubsub
import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:upubsub_mobile/BitcoinOfThings_feed.dart';

import '../mqtt_stream.dart';

// both sub and pub can open connection to server
// publication can be subscribed to by the pub owner
// as a general policy of the platform
abstract class BasePubSub {

  StreamController<StreamMessage> _streamController;
  // this is the stream to pipe messages into
  // if null then default to BOT Mux
  // if specified then stream is only for one topic
  BehaviorSubject<StreamMessage> _stream;

  set stream (s) { _stream = s; }

  BehaviorSubject<StreamMessage> get stream {
    if (_stream == null) {
      return BitcoinOfThingsMux.stream;
    }
    return _stream;
  }

  final String id;
  final String username;
  final String topic;

  String get clientId;

  // wss:// is for mqtt over websockets
  // final String server = 'wss://mqtt.bitcoinofthings.com';
  // final int port = 8884;
  // todo, make configurable
  final String server = 'mqtt.bitcoinofthings.com';
  final int port = 1883;

  // flag managed in UI subs view
  bool _enabled = false;

  bool get enabled { return this._enabled;}

  set enabled (bool val) {
      this._enabled = val;
   }

  // connection to the mqtt stream of data
  PubSubConnection _pubsub;

  set pubsub (PubSubConnection ps) { this._pubsub = ps;}

  BasePubSub(this.id, this.username, this.topic);

  // makes this into a single topic stream
  // listen to .stream for messages on one topic
  setSingleplexStream() {
    this._streamController = new BehaviorSubject();
    this._stream = _streamController.stream;
  }

  Future subscribe() async {
    var result;
      // try {
      print('start/stop sub here ${this.enabled}');
      if (_pubsub != null) {
        if (!this.enabled) {
          if ( _pubsub == null) {
            print('SORRY! PUBSUB IS NULL. WILL NOT UNSUBSCRIBE!');
          } else {
            await _pubsub.unsubscribe(this.topic);
          }
        }
        if (this.enabled) {
          result = await _pubsub.subscribe(this.topic);
        }
      }
    // }
    // catch (err) {
    //   // todo show error
    // }
    return result;
  }

  publish(String message) {
      if (_pubsub != null) {
        _pubsub.publish(topic, message);
      }
  }
}
