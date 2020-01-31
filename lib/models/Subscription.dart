import 'package:bot_demo_mobile/models/pubsub_base.dart';


class Subscription extends BasePubSub {
  //final String topic;
  final String name;
  final String status;
  //will be date time
  String expires;

  String get clientId { return this.id;}

  Subscription(String id, String username, String topic, this.name, this.status) : 
    super(id, username, topic);

  Subscription.fromJSON(Map<String, dynamic> json) :
    name = json['pub']['name'],
    status = json['status'], 
    super(json['clientId'], json['username'], json['pub']['topic']);
}
