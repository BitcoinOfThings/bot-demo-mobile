// to show list of publications user has created
import 'helpers/constants.dart';
import 'dart:async';
import 'dart:io';
import 'mqtt_stream.dart';
import 'package:flutter/material.dart';
import 'auth/auth_state.dart';
import 'components/localStorage.dart';
import 'components/pub_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/publication.dart';
import 'signin_page.dart';

class PubsViewBuilder extends StatelessWidget {

  final StreamController<AuthenticationState> _streamController;
  const PubsViewBuilder(this._streamController);

  Widget buildUi(BuildContext context, AuthenticationState s) {
    if (s.authenticated) {
      return PubsView();
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

class PubsView extends StatefulWidget {
  @override
  PubsState createState() => PubsState();
}

class PubsState extends State<PubsView> 
  with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Publication> _pubs = <Publication>[];

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

  putPubInState (Publication pub) {
    pub.pubsub = new PubSubConnection(pub);
    setState(() =>  _pubs.add(pub));
  }

  void listenForPubs() async {
    final Stream<Publication> stream = await getpubs();
    stream.listen(putPubInState);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _pubs.isEmpty 
      ? Center(child: Text('No Items found'))
      : ListView.builder(
        itemCount: _pubs.length,
        itemBuilder: (context, index) => 
          PublicationTile(_pubs[index]),
      );
    }
  }

Future<Stream<Publication>> getpubs() async {
 final String url = 'https://api.bitcoinofthings.com/getpubs';

 final client = new http.Client();

  var usercred = await LocalStorage.getJSON(Constants.KEY_CRED);
  //print(usercred);
  var auth = jsonEncode({"p":usercred["username"], "u":usercred["pass"]});
  //print(auth);

 var req = http.Request(
   'get', 
   Uri.parse(url))
   ..headers[HttpHeaders.contentTypeHeader] = "application/json";
 //req.headers.set(HttpHeaders.contentTypeHeader,"application/json");
 req.body = auth;
 final streamedRest = await client.send(req);

 return streamedRest.stream
     .transform(utf8.decoder)
     .transform(json.decoder)
     .expand((data) => (data as List))
     .map((data) => Publication.fromJSON(data));
}
