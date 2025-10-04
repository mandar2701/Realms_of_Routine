import 'dart:convert';
import 'package:http/http.dart' as http;
// Ensure you have a correct path to your Task model
import '../models/tasks.dart';

class TaskService {
  // 🚨 IMPORTANT: Replace with your actual backend server URL (e.g., http://10.0.2.2:3000/api/v1/tasks)
  // This URL targets the base endpoint for task operations.
  final String _baseUrl = 'http://localhost:3000/api/tasks';

  // MODIFIED: Helper function to generate standardized, token-authenticated headers
  Map<String, String> _headers(String token) => {
    'Content-Type': 'application/json; charset=UTF-8',
    // 🔑 Using the 'x-auth-token' key, matching your AuthService pattern
    'x-auth-token': token,
  };

  // --- CREATE Task ---
  // Requires the token passed from the TaskManager/UI layer
  Future<Task> createTask(Task task, String token) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: _headers(token), // Passes token via the header helper
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      // Use the httpErrorHandle utility if available, or just throw
      throw Exception(
        'Failed to create task. Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  // --- READ Tasks ---
  // Requires the token for fetching user-specific data
  Future<List<Task>> fetchTasks(String token) async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: _headers(token), // Passes token via the header helper
    );

    if (response.statusCode == 200) {
      List<dynamic> taskJsonList = jsonDecode(response.body);
      return taskJsonList.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks. Status: ${response.statusCode}');
    }
  }

  // --- UPDATE Task ---
  // Requires the token for permission to modify the document
  Future<void> updateTask(Task task, String token) async {
    if (task.id == null) throw Exception('Cannot update a task without an ID.');

    // Uses the task ID to target the specific MongoDB document
    final url = Uri.parse('$_baseUrl/${task.id}');

    final response = await http.patch(
      url,
      headers: _headers(token), // Passes token via the header helper
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to update task. Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }
}
