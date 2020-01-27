class MarketPublication {
  final String id;
  final String name;
  final String description;

  MarketPublication.fromJSON(Map<String, dynamic> jsonMap) :
    id = jsonMap['_id'],
    name = jsonMap['name'],
    description = jsonMap['description'];
}
