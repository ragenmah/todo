import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import '../models/todo_model.dart';
import 'repository.dart';

class TodoDbProvider implements Source, Cache {
  Database db;

  TodoDbProvider() {
    init();
  }

  void init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, 'todoList.db');

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        print(db);
        newDb.execute("""

        CREATE TABLE TodoList
        (
          id INTEGER PRIMARY KEY,
          title TEXT,
          descendants INTEGER,
          completed INTEGER,
          createdAt TEXT,
          updatedAt TEXT
        )
        
        """);
      },
    );
  }

  Future<int> addItem(TodoModel model) async {
    var result = await db.insert('TodoList', model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  // Update Operation: Update a Model object and save it to database
  Future<int> updateItem(TodoModel model) async {
    // var db = await this.database;
    var result = await db.update('TodoList', model.toJson(),
        where: 'id = ?', whereArgs: [model.id]);
    return result;
  }

  Future<TodoModel> fetchTodo(int id) async {
    final data = await db.query(
      "TodoList",
      // columns: null,
      columns: ["*"],
      where: "id = ?",
      whereArgs: [id],
    );

    if (data.length > 0) {
      return TodoModel.fromDB(data.first);
    }
    return null;
  }

  @override
  Future<List<int>> fetchAllTodo() {
    return null;
  }

  @override
  Future<int> clearCache() {
    return db.delete('Items');
  }
}

final TodoDbProvider dbProvider = TodoDbProvider();
