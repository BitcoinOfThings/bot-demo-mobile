// to show market publications
// select and link to sub page on site
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'helpers/urllauncher.dart';
import 'models/MarketPublication.dart';
import 'components/market_pub.dart';

class MarketView extends StatefulWidget {

  @override
  MarketState createState() => MarketState();

}

class MarketState extends State<MarketView> {
  List<MarketPublication> _pubs = <MarketPublication>[];

  @override
  void initState() {
    super.initState();
    listenForPubs();
  }

   @override
   void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void listenForPubs() async {
    final Stream<MarketPublication> stream = await getMarket();
    // can sometime get "stream has already been listened to"
    stream.listen((MarketPublication pub) =>
      setState(() => _pubs.add(pub))
    );
  }
  @override
  Widget build(BuildContext context) => 
  _pubs.isEmpty 
  ? FlatButton(child:Text('No Items.'), 
    onPressed: listenForPubs)
  : ListView.builder(
      itemCount: _pubs.length,
      itemBuilder: (context, index) {
        var pub = _pubs[index];
        return InkWell(
          onTap: () => onTapped(pub),
          child: MarketPublicationTile(pub)
        );
      },
  );
}

onTapped(MarketPublication pub) async {
  UrlLauncher.launch('sub/${pub.id}');
}

Future<Stream<MarketPublication>> getMarket() async {
 final String url = 'https://api.bitcoinofthings.com/marketplace';

 final client = new http.Client();
 //todo this can throw exeception
 //Exception has occurred.
 //ClientException (Write failed)
 final streamedRest = await client.send(
   http.Request('get', Uri.parse(url))
 );

 return streamedRest.stream
     .transform(utf8.decoder)
     .transform(json.decoder)
     .expand((data) => (data as List))
     .map((data) => MarketPublication.fromJSON(data));
}

