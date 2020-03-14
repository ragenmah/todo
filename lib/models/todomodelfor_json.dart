class TodoModelForJson {
  final int id;
  final String title;
  final bool completed;

  TodoModelForJson({this.id, this.title, this.completed});
  factory TodoModelForJson.fromJson(Map<String, dynamic> json) {
    return TodoModelForJson(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}
