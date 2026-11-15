import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/models/task_model.dart';
import 'package:http/http.dart' as http;

class TaskRemoteRepository {
  Future<TaskModel> createTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required DateTime dueAt,
  }) async {
    final res = await http.post(
      Uri.parse("${Constants.backendUri}/tasks/create"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'hexColor': rgbToHex(color),
        // Send UTC with a trailing Z so the server doesn't guess the timezone.
        'dueAt': dueAt.toUtc().toIso8601String(),
      }),
    );

    final body = jsonDecode(res.body) as Map<String, dynamic>;

    if (res.statusCode != 201) {
      throw body['message'] ?? 'Failed to create task';
    }
    return TaskModel.fromMap(body);
  }

  Future<List<TaskModel>> getTasks({required String token}) async {
    final res = await http.get(
      Uri.parse("${Constants.backendUri}/tasks"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // On success the backend returns a JSON array of tasks; on failure it
    // returns an error object like {"message": ...}.
    final body = jsonDecode(res.body);

    if (res.statusCode != 200) {
      final message = body is Map<String, dynamic> ? body['message'] : null;
      throw message ?? 'Failed to fetch tasks';
    }

    return (body as List<dynamic>)
        .map((e) => TaskModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
