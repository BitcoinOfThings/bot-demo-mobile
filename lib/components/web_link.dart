// link to a web page

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upubsub_mobile/helpers/urllauncher.dart';

Widget webLink (String linkText) {
  return GestureDetector(
    onTap: () => UrlLauncher.goHome(),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
      Icon(Icons.link),
      Text(linkText)
      ]
    )
  );
}