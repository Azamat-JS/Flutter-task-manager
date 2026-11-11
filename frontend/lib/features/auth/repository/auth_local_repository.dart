import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class AuthLocalRepository {
  String tableName = 'users';

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
    final path = join(dbPath, 'auth.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
 CREATE TABLE $tableName(
 id TEXT PRIMARY KEY,
 email TEXT NOT NULL,
 token TEXT NOT NULL,
 name TEXT NOT NULL,
 created_at INT NOT NULL,
 updated_at INT NOT NULL
 );
''');
      },
    );
  }
}
