// to show market publications
// select and link to sub page on site
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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

  void listenForPubs() async {
    final Stream<MarketPublication> stream = await getMarket();
    stream.listen((MarketPublication pub) =>
      setState(() =>  _pubs.add(pub))
    );
  }
  @override
  Widget build(BuildContext context) => 
  // Scaffold(
  //   appBar: AppBar(
  //     centerTitle: true,
  //     title: Text('Top Beers'),
  //   ),
  // );
  ListView.builder(
      itemCount: _pubs.length,
      itemBuilder: (context, index) => 
        MarketPublicationTile(_pubs[index]),
  );
  // Center(
  //       child: Container(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             // list goes here
  //           ]
  //           )
  //       )
  // );
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

  void fetchMarket() async {
    var data;
    //get market/public pubs from api
    var url = 'https://api.bitcoinofthings.com/listings';
      var response = await http.get(
        url
        );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        data = jsonResponse["data"];
        if (data != null ) {
          var itemCount = data.length;
          print(data);
          print('Number of pubs: $itemCount.');
        } else {
          print('Something went wrong. No data returned.');
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    return data;
  }
