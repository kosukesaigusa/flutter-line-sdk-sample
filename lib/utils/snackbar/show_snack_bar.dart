import 'package:flutter/material.dart';

void showFloatingSnackBar(BuildContext context, String message, {int seconds = 1}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: seconds),
  ));
}
