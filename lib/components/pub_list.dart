import 'package:flutter/material.dart';
import '../models/publication.dart';

class PublicationTile extends StatelessWidget {
  final Publication _pub;
  PublicationTile(this._pub);

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      ListTile(
        title: Text(_pub.name),
        subtitle: Text(_pub.description),
        // leading: Container(
        //   margin: EdgeInsets.only(left: 6.0),
        //   child: Image.network(_pub.icon, height: 50.0, fit: BoxFit.fill,)
        // ),
      ),
      Divider()
    ],
  );
}