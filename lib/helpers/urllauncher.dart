
// navigates to a web page

import 'package:url_launcher/url_launcher.dart' as launcher;

class UrlLauncher {
  static final homeurl = 'https://upubsub.com/';

  static isfullurl(String url) => 
    url.startsWith('http:') || url.startsWith('https://');
  
  static makeurl(String url) {
    if (isfullurl(url)) return url;
    return '$homeurl$url';
  }

  static goHome() async => launch(homeurl);

  static launch(String url) async {
    var gotourl = isfullurl(url) ? url : makeurl(url);
    if (await launcher.canLaunch(gotourl)) {
      await launcher.launch(gotourl);
      print('launched $url');
    } else {
      throw 'Could not launch $gotourl';
    }

  }

}
