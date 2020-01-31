// to show market publications
// select and link to sub page on site
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/MarketPublication.dart';
import 'components/market_pub.dart';
import 'package:url_launcher/url_launcher.dart';

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
    stream.listen((MarketPublication pub) =>
      setState(() =>  _pubs.add(pub))
    );
  }
  @override
  Widget build(BuildContext context) => 
  ListView.builder(
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
  //GlobalNotifier.show('You pressed ${pub.name}');
    var pubid = pub.id;
    var url = 'https://upubsub.com/sub/$pubid';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
}

Future<Stream<MarketPublication>> getMarket() async {
 final String url = 'https://api.bitcoinofthings.com/marketplace';

 final client = new http.Client();
 final streamedRest = await client.send(
   http.Request('get', Uri.parse(url))
 );

 return streamedRest.stream
     .transform(utf8.decoder)
     .transform(json.decoder)
     .expand((data) => (data as List))
     .map((data) => MarketPublication.fromJSON(data));
}

