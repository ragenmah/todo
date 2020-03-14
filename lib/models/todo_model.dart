import 'package:http/http.dart' as http;
import 'dart:convert';

class TodoModel {
  int _userid;
  int _id;
  String _title;
  bool _completed;
  String _createdAt;
  String _updatedAt;

  TodoModel(this._userid, this._id, this._title, this._completed,
      this._createdAt, this._updatedAt);
  int get userid => _userid;
  int get id => _id;

  String get title => _title;

  bool get completed => _completed;

  String get priority => _createdAt;

  String get date => _updatedAt;
  // DateTime updatedAt;
  // TodoModel();
  void toggleCompleted() {
    _completed = !completed;
  }

  set title(String newTitle) {
    if (newTitle.length <= 255 && newTitle.length != null) {
      this._title = newTitle;
    }
  }

  set date(String newDate) {
    this._createdAt = newDate;
  }

  TodoModel.fromJson(Map<String, dynamic> map) {
    //map from object
    this._userid = map["UserId"];
    _id = map["Id"];

    _title = map["Title"];
    _completed = map["Completed"] ?? false;
  }
  TodoModel.fromDB(Map<String, dynamic> dbData) {
    _userid = dbData["UserId"];
    _id = dbData["Id"];
    _title = dbData["Title"];
    _completed = dbData["Completed"] == 1;
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'UserId': userid,
      'Id': id,
      'Title': title,
      'Completed': completed,
    };
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['UserId'] = _userid;
    if (id != null) {
      map['Id'] = _id;
    }
    map['Title'] = _title;

    map['Completed'] = _completed;

    return map;
  }
}
