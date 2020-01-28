import 'package:flutter/material.dart';
import '../models/Subscription.dart';

class SubscriptionTile extends StatelessWidget {
  final Subscription _sub;
  SubscriptionTile(this._sub);

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      ListTile(
        title: Text(_sub.name),
        subtitle: Text(_sub.topic),
        // leading: Container(
        //   margin: EdgeInsets.only(left: 6.0),
        //   child: Image.network(_pub.icon, height: 50.0, fit: BoxFit.fill,)
        // ),
      ),
      Divider()
    ],
  );
}