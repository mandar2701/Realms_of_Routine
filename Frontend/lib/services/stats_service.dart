// Frontend/lib/services/stats_service.dart - COMPLETE MOCK IMPLEMENTATION

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Ensure the PlayerStats model and its nested Attributes class are imported
import '../models/player_stats.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';

class StatsService {
  final String baseUri = Constants.NODE_API_BASE_URL;

  // *** MOCK IMPLEMENTATION FOR PRESENTATION: Returns default Level 1 stats ***
  Future<PlayerStats?> fetchPlayerStats(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Return a new PlayerStats object starting at Level 1, XP 0.
    return PlayerStats(
      userId: userProvider.user.id,
      level: 1,
      xp: 0,
      statPoints: 0,

      // CRITICAL FIX: Instantiate the nested 'Attributes' object/class
      attributes: StatsAttributes(
        strength: 6,
        agility: 3,
        vigor: 7,
        stamina: 2,
        defense: 4,
      ),

      tasksCompleted: 0,
      questsFailed: 0,
    );
  }
}
