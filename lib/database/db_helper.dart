import '../models/todo_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static DBHelper _databaseHelper;
  static Database _database;

  String todoTable = 'TodoList';
  // String col_userid = 'userid';
  String colId = 'id';
  String colTitle = 'title';
  // String col_completed = 'completed';
  // String col_createdAt = 'createdAt';
  // String _updatedAt = 'updatedAt';

  DBHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DBHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DBHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todo.db';

    // Open/create the database at a given path
    var todosDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(("""

        CREATE TABLE TodoList
        (
          id INTEGER PRIMARY KEY,
          title TEXT,
          userid INTEGER,
          completed INTEGER,
          createdAt TEXT,
          updatedAt TEXT
        )
        
        """));
  }

  // Fetch Operation: Get all todo objects from database
  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $todoTable order by $colPriority ASC');
    var result = await db.query(todoTable, orderBy: '$colId ASC');
    return result;
  }

  // Insert Operation: Insert a todo object to database
  Future<int> inserttodo(TodoModel todo) async {
    Database db = await this.database;
    var result = await db.insert(todoTable, todo.toMap());
    return result;
  }

  // Update Operation: Update a todo object and save it to database
  Future<int> updatetodo(TodoModel todo) async {
    var db = await this.database;
    var result = await db.update(todoTable, todo.toMap(),
        where: '$colId = ?', whereArgs: [todo.id]);
    return result;
  }

  // Delete Operation: Delete a todo object from database
  Future<int> deletetodo(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $todoTable WHERE $colId = $id');
    return result;
  }

  // Get number of todo objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $todoTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'todo List' [ List<todo> ]
  Future<List<TodoModel>> gettodoList() async {
    var todoMapList = await getTodoMapList(); // Get 'Map List' from database
    int count =
        todoMapList.length; // Count the number of map entries in db table

    List<TodoModel> todoList = List<TodoModel>();
    // For loop to create a 'todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(TodoModel.fromJson(todoMapList[i]));
    }

    return todoList;
  }
}
