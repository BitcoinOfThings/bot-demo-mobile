import '../mqtt_stream.dart';

class Subscription {
  // wss:// is for mqtt over websockets
  // final String server = 'wss://mqtt.bitcoinofthings.com';
  // final int port = 8884;
  final String server = 'mqtt.bitcoinofthings.com';
  final int port = 1883;
  final String id;
  final String username;
  final String topic;
  final String name;
  final String status;
  //will be date time
  String expires;
  // flag managed in UI subs view
  bool _enabled = false;

  bool get enabled { return this._enabled;}

  // this setter should not subscribe! fix later
  set enabled (bool val) {
      this._enabled = val;
   }

  String get clientId { return this.id;}

  // the mqtt stream of data
  PubSubConnection _pubsub;

  set pubsub (PubSubConnection ps) { this._pubsub = ps;}

  Subscription(this.id, this.username, this.topic, this.name, this.status);

  Subscription.fromJSON(Map<String, dynamic> json) :
    id = json['clientId'],
    username = json['username'],
    topic = json['pub']['topic'],
    name = json['pub']['name'],
    status = json['status'];

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
      //all went well, complete the setter
    }
    catch (err) {
      // todo show error
      // leaves value unchanged so ui will revert
    }

  }
}
