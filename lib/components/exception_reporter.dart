import 'package:sentry/sentry.dart';

class ExceptionReporter {
 static final SentryClient _sentry = SentryClient(dsn: "https://fe6347ba2a2b445fab82bc9917e333d3@sentry.io/2385634");
 
 static bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

static reportException(error, [stackTrace]) async {
  if (false /*isInDebugMode*/) {
    print(stackTrace);
    print('In dev mode. Not sending report to Sentry.io.');
    return;
  }

  print('Reporting to Sentry.io...');

  final SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Success! Event ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}

}