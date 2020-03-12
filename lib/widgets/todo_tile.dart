import 'package:flutter/material.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/widgets/custom_add_todo.dart';

class TodoTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final Function checkboxCallback;
  final Function longPressCallback;
  final String date;
  // final TodoModel todo;
  TodoTile(
      {this.isChecked,
      this.taskTitle,
      this.checkboxCallback,
      this.longPressCallback,
      this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: longPressCallback,
      title: Text(
        taskTitle,
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(date.toString()),
      trailing: Checkbox(
        activeColor: Colors.lightBlueAccent,
        value: isChecked,
        onChanged: checkboxCallback,
      ),
      onTap: () {
        AddTodos(
//              addNewTask: addTask,
            // todo,
            'Edit Todo');
      },
    );
  }
}
//
