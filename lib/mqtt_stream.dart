//
// I used this code to explore interacting with mqtt and Streams using Dart.  I am
// new to Dart.  I am certain the code can use improvement.
// THE GOAL
// ========
// The goal of this code is to subscribe to a topic on mqtt.  As data comes in, the
// data is put into a Dart stream.  The Dart Stream can then be used by a StreamBuilder widget
// in the UI.
//
// THANKS TO THOSE THAT WENT BEFORE
// =================================
//    - Steve Hamblett's MQTT client for Dart (https://bit.ly/2DwBkZG).  A lot of the code was
//      copied/pasted from the the mqtt_client example (https://bit.ly/2DCk05G).
//
//
// SCENARIO
// ========
// In this example, we subscribe to an mqtt stream.  
// It is private so we authenticate with
// our username and password.  
// The stream of data is expected to be integers.  
// The data returned is
// put into a Stream so the rest of Flutter / Dart 
// can interact with the data.
//
//
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'BitcoinOfThings_feed.dart';
import 'components/localStorage.dart';
import 'models/Subscription.dart' as sub;

class PubSubConnection {
  //sub will have connection information
  //for now, support subs. later need pub conx too
  sub.Subscription _sub;
  Logger log;
  PubSubConnection(this._sub) {
    // Start logger.  MAKE SURE STRING IS NAME OF DART FILE WHERE
    // CODE IS (in this case the filename is mqtt_stream.dart)
    // TBD: I could not find a way to get the API to return the filename.
    log = Logger('mqtt_stream.dart');
  }
  MqttClient client;
  //
  // The caller could call subscribe many times.  Then many subscriptions would be available.
  // in some situations, this will make sense.  For now I limit to one subscription at a time.
  String previousTopic;
  bool bAlreadySubscribed = false;
//////////////////////////////////////////
// Subscribe to a mqtt topic.
  Future<bool> subscribe(String topic) async {
    // With await, we are assured of getting a string back and not a
    // Future<String> placeholder instance.
    // The rest of the code in the Main UI thread can continue.
    // I liked the explanation in the "Dart & Flutter Asnchronous Tutorial.."
    // https://bit.ly/2Dq12PJ
    //
    if (await _connectToClient() == true) {
      /// Add the unsolicited disconnection callback
      client.onDisconnected = _onDisconnected;

      /// Add the successful connection callback
      client.onConnected = _onConnected;

      /// Add a subscribed callback, there is also an unsubscribed callback if you need it.
      /// You can add these before connection or change them dynamically after connection if
      /// you wish. There is also an onSubscribeFail callback for failed subscriptions, these
      /// can fail either because you have tried to subscribe to an invalid topic or the broker
      /// rejects the subscribe request.
      client.onSubscribed = _onSubscribed;
      _subscribe(topic);
    }
    return true;
  }

//
// Connect to BitcoinOfThings
//
  Future<bool> _connectToClient() async {
    if (client != null &&
        client.connectionStatus.state == MqttConnectionState.connected) {
      log.info('already logged in');
    } else {
      client = await _login();
      if (client == null) {
        return false;
      }
    }
    return true;
  }

  /// The subscribed callback
  void _onSubscribed(String topic) {
    log.info('Subscription confirmed for topic $topic');
    this.bAlreadySubscribed = true;
    this.previousTopic = topic;
  }

  /// The unsolicited disconnect callback
  void _onDisconnected() {
    log.info('OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
      log.info(':OnDisconnected callback is solicited, this is correct');
    }
    // RTFM. Do not call disconnect from onDisconnected
    //client.disconnect();
  }

  /// The successful connect callback
  void _onConnected() {
    log.info('OnConnected client callback - Client connection was sucessful');
  }

  //
  // uses the config/private.json asset to get the 
  // API info.  config/private.json should be a file in .gitignore.
  // the intent is to hide this private info in a file that is not sync'd
  // with gitHub.
  //
  Future<Map> _getBrokerAndKey() async {
    var configFile = 'config/private.json';
    try {
      String connect = await rootBundle.loadString(configFile);
      return (json.decode(connect));
    } catch(FlutterError) {
      return {
        'broker': "127.0.0.1",
        'username': "",
        'key': ""
      };
    }
  }

  //
  // login to Service
  //
  Future<MqttClient> _login() async {
    // With await, we are assured of getting a string back and not a
    // Future<String> placeholder instance.
    // The rest of the code in the Main UI thread can continue.  When
    // the function completes, it will go ahead.
    // I liked the explanation in the "Dart & Flutter Asnchronous Tutorial.."
    // https://bit.ly/2Dq12PJ

    String server = '';
    String clientId = '';
    String username = '';
    String password = '';
    int port = 1883;
    if (_sub != null) {
      server = _sub.server;
      port = _sub.port;
      clientId = _sub.clientId;
      username = _sub.username;
      var usercred = await LocalStorage.getJSON("usercred");
      password = usercred["pass"];
    } else {
      Map connectJson = await _getBrokerAndKey();
      server = connectJson['broker'];
      clientId = connectJson['key'];
      username = connectJson['username'];
      password = connectJson['key'];
    }

    log.info('in _login....broker  : $server');
    log.info('in _login....clientId: $clientId');
    log.info('in _login....username: $username');
    log.info('in _login....password: $password');
    // server, client identifier
    client = MqttClient(server, clientId);
    client.port = port;
    //client.useWebSocket = true;
    // Turn on mqtt package's logging while in test.
    client.logging(on: true);
    final MqttConnectMessage connMess = MqttConnectMessage()
        // username, password
        .authenticateAs(username, password)
        // clientid, was demo
        .withClientIdentifier(clientId)
        .keepAliveFor(60) // Must agree with the keep alive set above or not set
        // .withWillTopic(
        //     'willtopic') // If you set this you must set a will message
        // .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    log.info('BOT client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however eill
    /// never send malformed messages.
    try {
      await client.connect();
    } on Exception catch (e) {
      log.severe('EXCEPTION::client exception - $e');
      client.disconnect();
      client = null;
      return client;
    }

    if (client == null) {
      // from exception above?
      print('Mqtt client null!');
    } else {
      if (client.connectionStatus.state == MqttConnectionState.connected) {
        log.info('BOT client connected');
      } else {
        /// Use status here rather than state if you also want the broker return code.
        log.info(
            'BOT client connection failed - disconnecting, status is ${client.connectionStatus}');
        client.disconnect();
        client = null;
      }
    }
    return client;
  }

//
// Subscribe to messages being published 
//
  Future _subscribe(String topic) async {
    // for now hardcoding the topic
    if (this.bAlreadySubscribed == true) {
      client.unsubscribe(this.previousTopic);
    }
    log.info('Subscribing to the topic $topic');
    client.subscribe(topic, MqttQos.atMostOnce);

    /// The client has a change notifier object(see the Observable class) 
    /// which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      /// The payload is a byte buffer, this will be specific to the topic
      BitcoinOfThingsMux.add(pt);
      log.info(
          'Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      return pt;
    });
  }

  Future unsubscribe(String topic) async {
      client.unsubscribe(this.previousTopic);
      this.bAlreadySubscribed = false;
    log.info('Unsubscribed from topic $topic');
  }

//////////////////////////////////////////
// Publish to a (BitcoinOfThings) mqtt topic.
  Future<void> publish(String topic, String value) async {
    // Connect to the client if we haven't already
    if (await _connectToClient() == true) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(value);
      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload);
    }
  }
}
