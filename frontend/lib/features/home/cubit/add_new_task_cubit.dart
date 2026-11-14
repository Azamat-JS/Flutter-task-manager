import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/home/repository/task_remote_repository.dart';
import 'package:frontend/models/task_model.dart';

part 'add_new_task_state.dart';

class AddNewTaskCubit extends Cubit<AddNewTaskState> {
  AddNewTaskCubit() : super(AddNewTaskInitial());
  final taskRemoteRepository = TaskRemoteRepository();
  Future<void> createNewTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      taskRemoteRepository.createTask(
        title: title,
        description: description,
        hexColor: color,
        token: token,
        dueAt: dueAt,
      );
    } catch (e) {
      emit(AddNewTaskError(e.toString()));
    }
  }
}
