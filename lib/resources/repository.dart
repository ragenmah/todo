import 'dart:async';
import '../models/todo_model.dart';
import 'todo_api_provider.dart';
import 'todo_db_provider.dart';

class Repository {
  List<Source> sources = [
    dbProvider,
    TodoApiProvider(),
  ];

  List<Cache> caches = [
    dbProvider,
  ];

  Future<List<int>> fetchAllTodo() async {
    return sources[1].fetchAllTodo();
  }

  Future<TodoModel> fetchItem(int id) async {
    TodoModel model;
    Source source;

    for (source in sources) {
      model = await source.fetchTodo(id);
      if (model != null) {
        break;
      }
    }

    for (var cache in caches) {
      if (cache != source) cache.addItem(model);
    }
    return model;
  }

  clearCache() async {
    for (var cache in caches) {
      await cache.clearCache();
    }
  }
}

abstract class Source {
  Future<TodoModel> fetchTodo(int id);
  Future<List<int>> fetchAllTodo();
}

abstract class Cache {
  Future<int> addItem(TodoModel model);
  Future<int> clearCache();
}
