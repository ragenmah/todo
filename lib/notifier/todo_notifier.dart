import 'dart:collection';
import 'package:flutter/cupertino.dart';

import '../models/todo_model.dart';

class TodoNotifier with ChangeNotifier {
  List<TodoModel> _todoList = [];
  TodoModel _currentTodo;

  UnmodifiableListView<TodoModel> get todoList =>
      UnmodifiableListView(_todoList);

  TodoModel get currentTodo => _currentTodo;
  int get todoCount {
    return _todoList.length;
  }

  set todoList(List<TodoModel> todoList) {
    _todoList = todoList;
    notifyListeners();
  }

  set currentTodo(TodoModel todo) {
    _currentTodo = todo;
    notifyListeners();
  }

  addTodo(TodoModel todo) {
    _todoList.insert(0, todo);
    notifyListeners();
  }

  deleteTodo(TodoModel todo) {
    _todoList.removeWhere((_todo) => _todo.id == todo.id);
    notifyListeners();
  }

  void updateTask(TodoModel todo) {
    todo.toggleCompleted();
    notifyListeners();
  }
}
