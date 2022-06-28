import 'package:flutter/material.dart';

abstract class ISnackBarDispatcher {
  void showText(String message, {int milliseconds = 2000});
}

class SnackBarDispatcher implements ISnackBarDispatcher {
  SnackBarDispatcher(GlobalKey<ScaffoldMessengerState> messengerKey)
      : _messengerKey = messengerKey;

  final GlobalKey<ScaffoldMessengerState> _messengerKey;

  @override
  void showText(String message, {int milliseconds = 2000}) {
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }
}
