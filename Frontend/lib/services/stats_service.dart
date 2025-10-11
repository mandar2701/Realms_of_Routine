// Frontend/lib/services/stats_service.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/player_stats.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import 'scaffold_messenger_service.dart'; // Import the service

class StatsService {
  final String baseUri = Constants.NODE_API_BASE_URL;

  Future<PlayerStats?> fetchPlayerStats(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.user.token;

    try {
      http.Response res = await http.get(
        Uri.parse('$baseUri/api/stats'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (res.statusCode == 200) {
        // ... return data ...
        // Placeholder for missing PlayerStats definition/import:
        // You would return PlayerStats.fromJson(jsonDecode(res.body)) here.
        return null;
      } else {
        // ✅ FIXED: Calling the static method directly on the class
        ScaffoldMessengerService.showSnackBar(
          context,
          'Failed to load player stats: ${jsonDecode(res.body)['error']}',
        );
        return null;
      }
    } catch (e) {
      // ✅ FIXED: Calling the static method directly on the class
      ScaffoldMessengerService.showSnackBar(
        context,
        'Error fetching stats: ${e.toString()}',
      );
      return null;
    }
  }
}
