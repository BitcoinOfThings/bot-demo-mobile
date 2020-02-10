// App shell
import 'dart:async';
import 'package:upubsub_mobile/BitcoinOfThings_feed.dart';
import 'package:flutter/material.dart';
import 'components/exception_reporter.dart';
import 'components/notifications.dart';
import 'home_page.dart';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

//
// added to route the logging info - the file and where in the file
// the message came from.
//

/// Reports [error] along with its [stackTrace] to Sentry.io.
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');

  // Errors thrown in development mode are unlikely to be interesting. You can
  // check if you are running in dev mode using an assertion and omit sending
  // the report.

  ExceptionReporter.reportException(error, stackTrace);

}

Future<Null> main() async {
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (ExceptionReporter.isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  initLogger();
  GlobalNotifier.wireUp();

  runZoned<Future<Null>>(() async {
    runApp(BOTApp());
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });

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
        botmsg.streamName != null ? botmsg.streamName : "unknown topic", 
        //TODO: decode, use .object
        botmsg.rawString);
      // then just show a notification
      GlobalNotifier.notifications.show(notemsg);
    } );
  }

  static void show(something) {
    var notemsg = NotificationMessage(
        'You ought to know...', 
        something);
    GlobalNotifier.notifications.show(notemsg);
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
      home: HomePage(title: 'uPub\$ub'),
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

