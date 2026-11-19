import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/home/repository/task_remote_repository.dart';
import 'package:frontend/models/task_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('syncTasks succeeds when the server returns a JSON array', () async {
    final task = TaskModel.fromMap({
      'id': 'task-1',
      'title': 'Offline task',
      'createdAt': '2026-01-01T09:00:00Z',
      'updatedAt': '2026-01-01T09:00:00Z',
      'dueAt': '2026-01-02T09:00:00Z',
      'isSynced': 0,
    });
    final client = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/tasks/sync');
      return http.Response('[{"id":"task-1"}]', 201);
    });

    final isSynced = await http.runWithClient(
      () =>
          TaskRemoteRepository().syncTasks(tasks: [task], token: 'test-token'),
      () => client,
    );

    expect(isSynced, isTrue);
  });
}
