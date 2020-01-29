import 'package:flutter/material.dart';
import '../models/Subscription.dart';

class SubscriptionTile extends StatefulWidget {
  /*final*/ Subscription _sub;
  SubscriptionTile(this._sub);

  @override
  SubscriptionTileState createState() => SubscriptionTileState(this._sub);
}

class SubscriptionTileState extends State<SubscriptionTile> {
  final Subscription _sub;
  bool _whyonevalue = false;

  SubscriptionTileState(this._sub);

  _valchanged(val) {
    setState(() { _whyonevalue = val; });
  }

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      SwitchListTile(
        title: Text(_sub.name),
        subtitle: Text(_sub.topic),
        value: _whyonevalue,
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