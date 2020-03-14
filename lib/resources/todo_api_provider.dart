import 'dart:convert';
import 'package:http/http.dart' show Client;
// import 'package:http/http.dart' as http;
import 'package:todo/notifier/todo_notifier.dart';
import 'package:todo/resources/repository.dart';

import '../models/todo_model.dart';

const _rootUrl = "https://jsonplaceholder.typicode.com/todos/";

class TodoApiProvider implements Source {
  Client client = Client();

  @override
  Future<TodoModel> fetchTodo(int id) async {
    final response = await client.get("$_rootUrl/$id");

    if (response.statusCode == 200) {
      return TodoModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Future<List<int>> fetchAllTodo() async {
    final response = await client.get("$_rootUrl");
    print("the ids response from the server $response");
    final ids = json.decode(response.body);
    print("The cast list of integer is $ids");
    return ids.cast<int>();
  }
}
