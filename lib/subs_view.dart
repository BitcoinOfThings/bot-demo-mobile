// show list of subs for user
import 'dart:async';

import 'package:bot_demo_mobile/mqtt_stream.dart';
import 'package:bot_demo_mobile/sub_view.dart';
import 'package:flutter/material.dart';
import 'auth/auth_state.dart';
import 'components/localStorage.dart';
import 'components/sub_list.dart';
import 'models/Subscription.dart';
import 'signin_page.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io';

class SubsViewBuilder extends StatelessWidget {

  final StreamController<AuthenticationState> _streamController;
  const SubsViewBuilder(this._streamController);

  Widget buildUi(BuildContext context, AuthenticationState s) {
    if (s.authenticated) {
      return SubsView();
    } else {
      return SignInPage(_streamController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<AuthenticationState>(
        stream: _streamController.stream,
        initialData: new AuthenticationState.initial(),
        builder: (BuildContext context,
            AsyncSnapshot<AuthenticationState> snapshot) {
          final state = snapshot.data;
          return buildUi(context, state);
        });
  }
}

class SubsView extends StatefulWidget {
  @override
  SubsState createState() => SubsState();
}

class SubsState extends State<SubsView> {
  final List<Subscription> _subs = <Subscription>[];

  @override
  void initState() {
    super.initState();
    listenForSubs();
  }

   @override
   void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void listenForSubs() async {
    // final Stream<Subscription> stream = await getsubs();
    // stream.listen((Subscription sub) =>
    //   setState(() =>  _subs.add(sub))
    // );
    // is there better way
    var subs = await getsubs();
    if (subs != null) {
      for (var i = 0; i < subs.length; i++) {
        // todo associate sub with mqtt stream
        var s = subs[i];
        s.pubsub = new PubSubConnection(s);
        setState(() => _subs.add(s));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return 
    Column(
    children: [Expanded(
      child:
      ListView.builder(
      itemCount: _subs.length,
      itemBuilder: (context, index) => 
        SubscriptionTile(_subs[index]),
      ),
      ),
            RaisedButton(
            child: const Text("Demo Sub"),
            splashColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) 
                => SubPage(title: "BOT Demo Sub")));
            }
          ),
    ]
    );
  }
}

// Future<Stream<Subscription>> getMarket() async {
//  final String url = 'https://api.bitcoinofthings.com/marketplace';

//  final client = new http.Client();
//  final streamedRest = await client.send(
//    http.Request('get', Uri.parse(url))
//  );

//  return streamedRest.stream
//      .transform(utf8.decoder)
//      .transform(json.decoder)
//      .expand((data) => (data as List))
//      .map((data) => MarketPublication.fromJSON(data));
// }

//should be Subscription!
  Future<List<dynamic>> getsubs() async {
    //get subs from api
    var url = 'https://api.bitcoinofthings.com/getsubs';
      var usercred = await LocalStorage.getJSON("usercred");
      //print(usercred);
      var auth = convert.jsonEncode({"p":usercred["username"], "u":usercred["pass"]});
      //print(auth);
      var response = await http.post(
        url,
        body: auth,
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        );
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        // data should be List<dynamic>
        var data = jsonResponse["data"];
        if (data != null ) {
          print(data);
          var subs = data
          .map(
            (dynamic item) => Subscription.fromJSON(item),
          );
          return subs.toList();
        } else {
          print('Not Authorized!');
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
      return null;
  }
