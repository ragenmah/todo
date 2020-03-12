import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/database/db_helper.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/notifier/todo_notifier.dart';
import '../widgets/todo_tile.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
// import 'package:http/http.dart' show Client;

const _rootUrl = "https://jsonplaceholder.typicode.com/todos";

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  DBHelper dbHelper = DBHelper();
  List<TodoModel> todoList;
  int count = 0;
  List<TodoModel> _todoList = List<TodoModel>();
  Future<List<TodoModel>> fetchAllTodos() async {
    final response = await http.get("$_rootUrl");
    print("the ids response from the server $response");
    var todoList = List<TodoModel>();

    if (response.statusCode == 200) {
      var todoJson = json.decode(response.body);
      for (var todoJson in todoJson) {
        todoList.add(TodoModel.fromJson(todoJson));
      }
    } else {
      throw Exception('Failed to load post');
    }
    return todoList;
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchAllTodos().then((value) {
      setState(() {
        _todoList.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<TodoModel>();
      updateListView();
    }
    return Consumer<TodoNotifier>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            // final task = taskData.todoList[index];
            return index == 0
                ? Center(child: Text("No data"))
                : TodoTile(
                    // taskTitle: task.title,
                    // isChecked: task.completed,
                    taskTitle: _todoList[index].title == null
                        ? ""
                        : _todoList[index].title,
                    isChecked: _todoList[index].completed,
                    date: _todoList[index].date,
                    checkboxCallback: (bool checkboxState) {
                      taskData.updateTask(_todoList[index]);
                      dbHelper.updatetodo(_todoList[index]);
                    },
                    longPressCallback: () {
                      taskData.deleteTodo(_todoList[index]);
                      dbHelper.deletetodo(_todoList[index].id);
                    },
                  );
          },
          // itemCount: taskData.todoCount,
          itemCount: 5,
          padding: EdgeInsets.only(
            top: 20.0,
            left: 20.0,
            right: 20.0,
            bottom: 0,
          ),
        );
      },
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TodoModel>> noteListFuture = dbHelper.gettodoList();
      noteListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }
}
