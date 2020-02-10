// a service that shows dialogs
// see https://medium.com/flutter-community/manager-your-flutter-dialogs-with-a-dialog-manager-1e862529523a

import 'dart:async';

import 'exception_reporter.dart';
class DialogService {
  Function _showDialogListener;
  Completer _dialogCompleter;
  /// Registers a callback function. Typically to show the dialog
  void registerDialogListener(Function showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  void deregisterDialogListener() {
    _showDialogListener = null;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future showDialog() {
    _dialogCompleter = Completer();
    _showDialogListener();
    return _dialogCompleter.future;
  }
  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogComplete() {
    if (_dialogCompleter == null) {
      ExceptionReporter.reportException(
        Exception("In DialogService.dialogComplete _dialogCompleter is null")
      );
    }
    _dialogCompleter?.complete();
    _dialogCompleter = null;
  }
}