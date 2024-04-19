import 'dart:convert';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/todo_list_model.dart';

// Database provider class
class TodoProvider {
  // Database instance
  static Database? _database;

  // Database name
  static const String _databaseName = 'todo.db';

  // Database version
  static const int _databaseVersion = 1;

  // Table name
  static const String _tableName = 'todo';

  // Column names
  static const String _columnId = 'id';
  static const String _columnTitle = 'title';
  static const String _columnDescription = 'description';
  static const String _columnisPinned = 'isPinned';

  // Initialize the database
  static Future<void> init() async {
    // Get the path to the database directory
    final databasePath = join(await getDatabasesPath(), _databaseName);

    /// drop database code line
    // await deleteDatabase(databasePath);

    // Check if the database file exists
    final databaseExists = await File(databasePath).exists();

    if (!databaseExists) {
      // If the database does not exist, create it
      _database = await openDatabase(
        databasePath,
        version: _databaseVersion,
        onCreate: (db, version) async {
          await db.execute('CREATE TABLE $_tableName('
              '$_columnId INTEGER PRIMARY KEY AUTOINCREMENT,'
              '$_columnTitle TEXT,'
              '$_columnDescription TEXT,'
              '$_columnisPinned INTEGER DEFAULT 0)');
        },
      );
    } else {
      // If the database exists, open it
      _database = await openDatabase(
        databasePath,
        version: _databaseVersion,
      );
    }
  }

  // Insert a todo
  Future<void> insert(TodoModel todo) async {
    try {
      //remove all the todos
      // await _database!.delete(_tableName);
      await _database!.insert(
        _tableName,
        todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Update a todo
  Future<void> update(TodoModel todo) async {
    final Map<String, dynamic> todoMap = todo.toMap();
    await _database!.update(
      _tableName,
      todoMap,
      where: '$_columnId = ?',
      whereArgs: [todoMap[_columnId]],
    );
  }

  // Delete a todo
  Future<void> delete(int id) async {
    await _database!.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  // Get a todo by id
  Future<TodoModel> todoById(int id) async {
    final List<Map<String, dynamic>> todos = await _database!.query(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );

    return TodoModel.fromMap(todos.first);
  }

  // Get all todos and return them as a JSON-encoded string
  Future<List<TodoModel>> todos() async {
    final List<Map<String, dynamic>> todos = await _database!.query(_tableName);

    // Map each Map<String, dynamic> to a TodoModel object
    final List<TodoModel> todoList =
        todos.map((todo) => TodoModel.fromMap(todo)).toList();

    return todoList;
  }

  //Get last todo
  Future<TodoModel> lastTodo() async {
    final List<Map<String, dynamic>> todos = await _database!.query(_tableName);

    return TodoModel.fromMap(todos.last);
  }
}
