import 'package:frontend/models/task_model.dart';

sealed class AddNewTaskState {
  const AddNewTaskState();
}

final class AddNewTaskLoading extends AddNewTaskState {}

final class AddNewTaskError extends AddNewTaskState {}

final class AddNewTaskSuccess extends AddNewTaskState {
  final TaskModel taskModel;

  const AddNewTaskSuccess(this.taskModel);
}
