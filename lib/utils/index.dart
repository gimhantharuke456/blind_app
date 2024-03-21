import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension BuildContextExtension on BuildContext {
  showSnackBar(String? message,
      [Function? completion, Duration duration = const Duration(seconds: 4)]) {
    if (message != null) {
      final snackBar = SnackBar(
        content: Text(_capitalizeFirstLetter(message)),
        duration: duration,
      );
      ScaffoldMessenger.of(this).showSnackBar(snackBar).closed.then((value) {
        if (completion != null) {
          completion();
        }
      });
    }
  }

  String _capitalizeFirstLetter(String text) {
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  navigator(BuildContext context, Widget child,
      {bool shouldBack = true, bool shouldAuthenticate = true}) {
    if (!shouldBack) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => child));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => child));
  }
}

extension DateTimeExtension on DateTime {
  String formatDate() {
    DateFormat formatter = DateFormat('yyyy:MM:dd');
    return formatter.format(toLocal());
  }

  String formatTime() {
    DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(toLocal());
  }
}
