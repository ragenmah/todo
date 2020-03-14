class Todo {
  int _id;
  String _title;
  String _description;
  String _date;
  bool _completed;

  Todo(this._title, this._date, this._completed, [this._description]);

  Todo.withId(this._id, this._title, this._date, this._completed,
      [this._description]);

  int get id => _id;

  String get title => _title;

  String get description => _description;

  String get date => _date;

  bool get completed => _completed;
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set completed(bool newCompleted) {
    if (newCompleted == null) {
      this._completed = false;
    }
    this._completed = newCompleted;
  }

  set date(String newDate) {
    this._date = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['completed'] = _completed ?? false;
    return map;
  }

  // Extract a Note object from a Map object //json
  Todo.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
    this._completed = map['completed'] == 1;
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      // 'UserId': userid,
      'Id': id,
      'Title': title,
      'Completed': completed,
    };
  }

//  factory Todo.fromJson(Map<String, dynamic> json) {
//     return Todo(
//       id : json['id'],
//     title : json['title'],
//     description :json['description'];
//     date : json['date'];
//     completed : json['completed'] ,
//  );
  //}
  // Todo.fromJson(Map<String, dynamic> map) {
  //   this._id = map['id'];
  //   this._title = map['title'];
  //   this._description = map['description'];
  //   this._date = map['date'];
  // }
}
