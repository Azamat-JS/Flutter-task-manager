import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/models/task_model.dart';
import 'package:http/http.dart' as http;

class TaskRemoteRepository {
  Future<TaskModel> createTask({
    required String title,
    required String description,
    required hexColor,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("${Constants.backendUri}/tasks"),
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: jsonEncode({
          'title': title,
          'description': description,
          'hexColor': hexColor,
          'dueAt': dueAt.toIso8601String(),
        }),
      );

      final body = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode != 201) {
        throw body['message'] ?? 'Failed to fetch user';
      }
      return TaskModel.fromJson(res.body);
    } catch (e) {
      rethrow;
    }
  }
}
