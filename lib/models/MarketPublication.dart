
// a public listing in the marketplace
class MarketPublication {
  final String id;
  final String name;
  final String description;
  // todo
  // isgroup, duration, last pub time, price, icon

  MarketPublication.fromJSON(Map<String, dynamic> jsonMap) :
    id = jsonMap['_id'],
    name = jsonMap['name'],
    description = jsonMap['description'];
}
