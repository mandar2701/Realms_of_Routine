import 'package:flutter/material.dart';

class ScaffoldMessengerService {
  // This GlobalKey is the way to access the ScaffoldMessengerState from anywhere.
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // 🆕 Add the static method to show the SnackBar
  static void showSnackBar(BuildContext context, String message) {
    final SnackBar snackBar = SnackBar(content: Text(message));

    // Call showSnackBar on the current state of the GlobalKey
    if (messengerKey.currentState != null) {
      messengerKey.currentState!.showSnackBar(snackBar);
    }
    // It's also possible to fall back to the traditional method if needed,
    // but the key method is generally preferred.
    else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
