// UI component that wraps the stream
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:upubsub_mobile/mqtt_stream.dart';

/*
* Currently, there will be one stream for all
* BOT subscriptions. But this may change in future
* as app needs change.
* Going to call this thing a Multiplexer for now.
*/
class BitcoinOfThingsMux {
  //
  // Both the StreamController and Stream are defined as static. This
  // means they both belong to the class and not to an instance.
  // It was my way of getting to what I was used to via Singleton
  // functionality in some other languages.
  //
  // A Stream controller alerts the stream when new data is available.
  // The controller should be private.
  static StreamController<StreamMessage> _feedController = 
    BehaviorSubject();

  // Expose the stream so a StreamBuilder can use it.
  // Issue with default stream, fixed with rxdart.
  // "Bad State: Stream has already been listened to"
  static BehaviorSubject<StreamMessage> get stream => 
    _feedController.stream;

  static void close() {
    _feedController.close();
  }

  //
  // TODO: could be string or json message
  // this method called from PubSubConnection
  // IOW, all BOT streams are multiplexed
  // into this one stream. That may change.
  static void add(StreamMessage streamMessage) {
    Logger log = Logger('BitcoinOfThings_feed.dart');
    try {
      _feedController.add(streamMessage);
      log.info('---> added value to the Stream... the value is: ${streamMessage.rawString}');
    } catch (e) {
      log.severe(
        '${streamMessage.rawString} was published to the feed.  Error adding to the Stream: $e');
    }
  }
}
