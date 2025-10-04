import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:life_xp_project/services/scaffold_messenger_service.dart'; // 👈 Step 1: IMPORT the service

// Step 2: REMOVE BuildContext from the function signature
void showSnackBar(String text) {
  // Use the GlobalKey to access the ScaffoldMessenger's state safely.
  // The '?' is a null-aware operator in case the state is not available.
  ScaffoldMessengerService.messengerKey.currentState?.showSnackBar(
    SnackBar(content: Text(text)),
  );
}

// Step 3: REMOVE BuildContext from this function's signature as well
void httpErrorHandle({
  required http.Response response,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      // Call the updated showSnackBar function (no context needed)
      showSnackBar(jsonDecode(response.body)['msg']);
      break;
    case 500:
      // Call the updated showSnackBar function (no context needed)
      showSnackBar(jsonDecode(response.body)['error']);
      break;
    default:
      // Call the updated showSnackBar function (no context needed)
      showSnackBar(response.body);
  }
}
