class Subscription {
  final String id;
  final String user;
  final String topic;
  final String name;

  Subscription(this.id, this.user, this.topic, this.name);

  Subscription.fromJSON(Map<String, dynamic> json) :
    id = json['_id'],
    user = json['clientId'],
    topic = json['pub']['topic'],
    name = json['pub']['name'];
}
