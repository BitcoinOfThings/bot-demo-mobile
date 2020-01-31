// base class for pubsub
import '../mqtt_stream.dart';

// both sub and pub can open connection to server
// publication can be subscribed to by the pub owner
// as a general policy of the platform
abstract class BasePubSub {

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

  subscribe() async {
      try {
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
          await _pubsub.subscribe(this.topic);
        }
      }
    }
    catch (err) {
      // todo show error
    }
  }

}
