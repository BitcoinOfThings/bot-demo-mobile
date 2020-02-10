import 'dart:async';

import 'package:event_bus/event_bus.dart';

typedef void WhenSomethingFunc(AppMessage event);

class AppMessage {
  final String topic;
  final Map<String, dynamic> payload;
  AppMessage(this.topic, this.payload);
}

// Application Event bus
class Bus {
  static final EventBus _bus = EventBus();
  // publish an event
  static void publishMessage(AppMessage event) => _bus.fire(event);
  static void publish(String topic, Map<String, dynamic> payload) => _bus.fire(
    AppMessage(topic, payload));

  // subscribe to events
  // caller needs to manage subscription
  static StreamSubscription subscribe(WhenSomethingFunc func) {
    return _bus.on<AppMessage>().listen(
      (event) => func(event)
    );
  }

}
