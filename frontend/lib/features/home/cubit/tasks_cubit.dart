import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/home/repository/task_local_repository.dart';
import 'package:frontend/features/home/repository/task_remote_repository.dart';
import 'package:frontend/models/task_model.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());
  final taskRemoteRepository = TaskRemoteRepository();
  final taskLocalRepository = TaskLocalRepository();

  Future<void> createNewTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required DateTime dueAt,
    required String uid,
  }) async {
    try {
      emit(TasksLoading());
      final taskModel = await taskRemoteRepository.createTask(
        uid: uid,
        title: title,
        description: description,
        color: color,
        token: token,
        dueAt: dueAt,
      );
      await taskLocalRepository.insertTask(taskModel);
      emit(TasksSuccess(taskModel));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> getAllTasks({required String token}) async {
    try {
      emit(TasksLoading());
      final tasks = await taskRemoteRepository.getTasks(token: token);
      emit(GetTasksSuccess(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> syncTasks(String token) async {
    final unsyncTasks = await taskLocalRepository.getUnsyncedTasks();
    if (unsyncTasks.isEmpty) {
      return;
    }
    print(unsyncTasks);
    final isSynced = await taskRemoteRepository.syncTasks(
      tasks: unsyncTasks,
      token: token,
    );
    if (isSynced) {
      print('synced done');
      for (final task in unsyncTasks) {
        taskLocalRepository.updateRowValue(task.id, 1);
      }
    }
  }
}
