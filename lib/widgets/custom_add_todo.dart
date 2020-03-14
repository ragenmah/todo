import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/db_helper.dart';
import 'package:todo/models/todo_model.dart';

class AddTodos extends StatefulWidget {
  final String actionName;
  // final TodoModel todo;
  AddTodos(this.actionName);
  @override
  _AddTodosState createState() => _AddTodosState();
}

class _AddTodosState extends State<AddTodos> {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  Function addNewTask;
  DBHelper helper = DBHelper();
  String actionName;
  TodoModel todo;
  String typedName;
  TextEditingController titleController = TextEditingController();

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 1095)),
    );

    if (picked != null && picked != _date) {
      print("Date selected ${_date.toString()}");
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (todo.title != null) {
    //   titleController.text = todo.title;
    // } else {
    //   titleController.text = "";
    // }
    return Container(
      // color: Color(0xff757575),
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                actionName == null ? '' : actionName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.lightBlueAccent,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextField(
                autofocus: true,
                textAlign: TextAlign.center,
                onChanged: (String value) {
                  typedName = value;
                  todo.title = titleController.text.toString();
                  print(typedName);
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              TextField(
                autofocus: true,
                //textAlign: TextAlign.center,
              ),
              Text('Date selected: ${_date.toString()}'),
              // GestureDetector(
              //   child: Icon(
              //     Icons.calendar_today,
              //     color: Colors.grey,
              //   ),
              //   onTap: () {
              //     print("hh");
              //     _selectDate(context);
              //   },
              // ),
              RaisedButton(
                child: Icon(Icons.calendar_today),
                onPressed: () {
                  _selectDate(context);
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              FlatButton(
                  textColor: Colors.white,
                  padding: EdgeInsets.all(15.0),
                  child: Text('Add'),
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    // Provider.of<TodoNotifier>(context).addTask(typedName);
                    _save();
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    // moveToLastScreen();

    todo.date = _date.toString();
    int result;
    if (todo.id != null) {
      // Case 1: Update operation
      result = await helper.updatetodo(todo);
    } else {
      // Case 2: Insert Operation
      result = await helper.inserttodo(todo);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Your Todo Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Todo');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
