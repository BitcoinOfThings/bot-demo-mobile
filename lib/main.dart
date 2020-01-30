// App shell
import 'dart:async';

import 'package:bot_demo_mobile/BitcoinOfThings_feed.dart';
import 'package:flutter/material.dart';
import 'components/notifications.dart';
import 'home_page.dart';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

//
// added to route the logging info - the file and where in the file
// the message came from.
//

void main() {
  initLogger();
  GlobalNotifier.wireUp();
  runApp(BOTApp());
}

// one notifier for all sub streams (for now)
// could cause memory leaks if not careful
class GlobalNotifier {
  // anywhere in app call 
  // GlobalNotifier.notifications.show(...)
  static Notifications notifications = new Notifications();
  static StreamSubscription botMux;

  static void wireUp () {
    GlobalNotifier.botMux = BitcoinOfThingsMux.stream.listen( (botmsg) {
      var notemsg = NotificationMessage(
        'unknown topic', 
        botmsg);
      // then just show a notification
      GlobalNotifier.notifications.show(notemsg);
    } );
  }

  static void cancel() { 
    botMux?.cancel(); 
    BitcoinOfThingsMux.close();
  }

  static void pause() { botMux?.pause(); }
  static void resume() { botMux?.resume(); }

}

class BOTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BOT Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Bitcoin Of Things (BOT) Mobile'),
    );
  }
}

void initLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      final List<Frame> frames = Trace.current().frames;
      try {
        final Frame f = frames.skip(0).firstWhere((Frame f) =>
            f.library.toLowerCase().contains(rec.loggerName.toLowerCase()) &&
            f != frames.first);
        print(
            '${rec.level.name}: ${f.member} (${rec.loggerName}:${f.line}): ${rec.message}');
      } catch (e) {
        print(e.toString());
      }
    });
  }

// listens to bot messages and pipes them into 
// notifications
void wireupBotStreamsToNotifier() {
  // when we get a bot message into our app
}