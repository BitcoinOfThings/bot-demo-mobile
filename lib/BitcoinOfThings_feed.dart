// UI component that wraps the stream
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

class BitcoinOfThingsFeed {
  //
  // Both the StreamController and Stream are defined as static. This
  // means they both belong to the class and not to an instance.
  // It was my way of getting to what I was used to via Singleton
  // functionality in some other languages.
  //
  // A Stream controller alerts the stream when new data is available.
  // The controller should be private.
  static StreamController<String> _feedController = 
    BehaviorSubject();

  // Expose the stream so a StreamBuilder can use it.
  // issue is showing sub, nav to other view then go back to sub
  // view tries to connect to stream again and get error
  // "Bad State: Stream has already been listened to"
  // static Stream<String> get sensorStream => 
  //   _feedController.stream.asBroadcastStream();
  static BehaviorSubject<String> get sensorStream => 
    _feedController.stream;


//
// TODO: add takes in a string, but forces the feed to be an int
  static void add(String value) {
    Logger log = Logger('BitcoinOfThings_feed.dart');
    try {
      _feedController.add(value);
      log.info('---> added value to the Stream... the value is: $value');
    } catch (e) {
      log.severe(
          '$value was published to the feed.  Error adding to the Stream: $e');
    }
  }
}
