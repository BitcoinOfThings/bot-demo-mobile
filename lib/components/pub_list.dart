import 'package:flutter/material.dart';
import '../models/publication.dart';

class PublicationTile extends StatelessWidget {
  final Publication _pub;
  PublicationTile(this._pub);

  _valchanged(val) {
    this._pub.enabled = val;
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