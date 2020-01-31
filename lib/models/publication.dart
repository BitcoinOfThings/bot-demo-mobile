
import 'package:bot_demo_mobile/models/pubsub_base.dart';

class Publication extends BasePubSub {
  // use username instead of user
  //final String user;
  final String name;
  final String description;

  // for pub use username as clientid, might need something more unique 
  String get clientId { return username; }

  Publication(String id, String user, String topic, this.name,
    this.description) : super(id, user, topic);

  Publication.fromJSON(Map<String, dynamic> json) :
    name = json['name'],
    description = json['description'], super(json['_id'], json['userId'], json['topic']);

}
