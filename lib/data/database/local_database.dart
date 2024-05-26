// ignore_for_file: depend_on_referenced_packages

import 'package:finfresh_test/model/user_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE todos (
      _id $idType,
      title $textType,
      description $textType
    )
    ''');
  }

  Future<bool> todoExists(String id) async {
    final db = await instance.database;
    final result = await db.query(
      'todos',
      columns: ['_id'],
      where: '_id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<void> insertTodos(List<TodoModel> todos) async {
    final db = await instance.database;
    final batch = db.batch();

    for (TodoModel todo in todos) {
      if (!await todoExists(todo.id!)) {
        batch.insert('todos', TodoModel.toJson(todo));
        print('todo id ${todo.id}');
      }

      await batch.commit(noResult: true);
    }
  }

  Future<List<TodoModel>> getAllTodos() async {
    final db = await instance.database;
    final result = await db.query('todos');
    return result.map((json) => TodoModel.fromJson(json)).toList();
  }
}
