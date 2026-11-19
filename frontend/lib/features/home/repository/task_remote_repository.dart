import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/home/repository/task_local_repository.dart';
import 'package:frontend/models/task_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class TaskRemoteRepository {
  final taskLocalRepository = TaskLocalRepository();
  Future<TaskModel> createTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required String uid,
    required DateTime dueAt,
  }) async {
    try {
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
          'dueAt': dueAt.toUtc().toIso8601String(),
        }),
      );

      final body = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode != 201) {
        throw body['message'] ?? 'Failed to create task';
      }
      return TaskModel.fromMap(body);
    } catch (e) {
      try {
        final taskModel = TaskModel(
          id: const Uuid().v4(),
          uid: uid,
          title: title,
          description: description,
          color: color,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          dueAt: dueAt,
          isSynced: 0,
        );
        await taskLocalRepository.insertTask(taskModel);
        return taskModel;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<List<TaskModel>> getTasks({required String token}) async {
    try {
      final res = await http.get(
        Uri.parse("${Constants.backendUri}/tasks"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(res.body);

      if (res.statusCode != 200) {
        final message = body is Map<String, dynamic> ? body['message'] : null;
        throw message ?? 'Failed to fetch tasks';
      }

      final tasks = (body as List<dynamic>)
          .map((e) => TaskModel.fromMap(e as Map<String, dynamic>))
          .toList();
      await taskLocalRepository.insertTasks(tasks);
      return tasks;
    } catch (e) {
      final tasks = await taskLocalRepository.getTasks();
      if (tasks.isNotEmpty) {
        return tasks;
      }
      rethrow;
    }
  }
}
