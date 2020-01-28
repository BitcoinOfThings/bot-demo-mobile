
class Publication {
  final String id;
  final String user;
  final String topic;
  final String name;
  final String description;

  Publication(this.id, this.user, this.topic, this.name,
    this.description);

  Publication.fromJSON(Map<String, dynamic> json) :
    id = json['_id'],
    user = json['userId'],
    topic = json['topic'],
    name = json['name'],
    description = json['description'];

}