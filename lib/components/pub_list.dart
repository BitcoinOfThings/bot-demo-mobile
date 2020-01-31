import 'package:flutter/material.dart';
import '../models/publication.dart';

class PublicationTile extends StatefulWidget {
  final Publication _pub;

  PublicationTile(this._pub);

  @override
  PublicationTileState createState() => PublicationTileState(this._pub);
}

class PublicationTileState extends State<PublicationTile> {
  final Publication _pub;
  PublicationTileState(this._pub);

  _valchanged(val) {
    // setstate required?
    setState(() { this._pub.enabled = val; });
    this._pub.subscribe();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      SwitchListTile(
        title: Text(_pub.name),
        //subtitle: Text(_sub.description),
        value: this._pub?.enabled,
        onChanged: (bool value) { _valchanged(value); },
        // leading: Container(
        //   margin: EdgeInsets.only(left: 6.0),
        //   child: Image.network(_pub.icon, height: 50.0, fit: BoxFit.fill,)
        // ),
      ),

      Divider()
    ],
  );
}