import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/models/todo.dart';
import 'package:todo/models/todomodelfor_json.dart';

class TodoAppState with ChangeNotifier {
  TodoAppState();
  String _displayTitle = "";
  TodoAppState _currentTodo;
  void setDisplayTitle(String title) {
    _displayTitle = title;
    notifyListeners();
  }

  TodoAppState get currentTodo => _currentTodo;
  String get getDisplayTitle => _displayTitle;

  static const String _dataUrl = "https://jsonplaceholder.typicode.com/todos";
  String _jsonResonse = "";
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  Future<void> fetchData() async {
    _isFetching = true;
    notifyListeners();

    var response = await http.get(_dataUrl);
    if (response.statusCode == 200) {
      _jsonResonse = response.body;
    }

    _isFetching = false;
    notifyListeners();
  }

  String get getResponseText => _jsonResonse;

  List<dynamic> getResponseJson() {
    if (_jsonResonse.isNotEmpty) {
      Map<String, dynamic> json = jsonDecode(_jsonResonse);
      return json[0];
    }
    return null;
  }

  Future<List<TodoModelForJson>> fetechTodo() async {
    var response = await http.get(_dataUrl);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((todo) => new TodoModelForJson.fromJson(todo))
          .toList();
    } else {
      throw Exception('Failed to load Todo');
    }
  }

  static Future<List<dynamic>> getTodo() async {
    List<Todo> todoList = [];
    var response = await http.get(_dataUrl);
    print(response);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<List<int>> fetchTopStories() async {
    final response = await http.get("$_dataUrl");
    print("the ids respons from the server $response");
    final ids = json.decode(response.body);
    print("The cast list of integer is $ids");
    return ids.cast<int>();
  }

  // Future<Todo> fetchTopStories() async {
  //   final response = await http.get("$_dataUrl");
  //   // print("the ids respons from the server $response");
  //   final result = json.decode(response.body);
  //   // print("The cast list of integer is $ids");
  //   final Todo model =Todo.fromMapObject(result).
  //   return model;
  // }
}
