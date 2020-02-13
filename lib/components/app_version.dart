import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;
  return '$appName $packageName v$version $buildNumber';
}

showAppVersion() async {
  return Text(await getAppVersion());
}