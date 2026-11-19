import 'package:frontend/models/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalRepository {
  String tableName = 'tasks';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    return openDatabase(
      path,
      version: 4,
      onCreate: (db, _) => _createTable(db),
      onUpgrade: _upgradeTable,
    );
  }

  Future<void> _createTable(Database db) {
    return db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        uid TEXT NOT NULL,
        dueAt TEXT NOT NULL,
        hexColor TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        isSynced INT NOT NULL
      )
    ''');
  }

  Future<void> _upgradeTable(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    final oldTableName = '${tableName}_legacy';
    final color = oldVersion < 2
        ? "'FFFFFF'"
        : "COALESCE(NULLIF(color, 'default_color'), 'FFFFFF')";
    final isSynced = oldVersion < 3 ? '1' : 'isSynced';

    await db.execute('ALTER TABLE $tableName RENAME TO $oldTableName');
    await _createTable(db);
    await db.execute('''
      INSERT INTO $tableName (
        id, title, description, uid, dueAt, hexColor, createdAt, updatedAt, isSynced
      )
      SELECT id, title, description, uid, duaAt, $color, createdAt, updatedAt, $isSynced
      FROM $oldTableName
    ''');
    await db.execute('DROP TABLE $oldTableName');
  }

  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;

    final batch = db.batch();
    for (final task in tasks) {
      batch.insert(
        tableName,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [task.id]);
    await db.insert(tableName, task.toMap());
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final res = await db.query(tableName);

    if (res.isNotEmpty) {
      List<TaskModel> tasks = [];
      for (final elem in res) {
        tasks.add(TaskModel.fromMap(elem));
      }
      return tasks;
    }
    return [];
  }
}
