import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/todomodelfor_json.dart';
import 'package:todo/screens/calls.dart';
import '../Models/todo.dart';
import '../database/todo_dbhelper.dart';
import '../screens/todo_detail.dart';
import 'package:sqflite/sqflite.dart';
import '../notifier/todo_app_state.dart';

class TodoList extends StatefulWidget {
  final String tabDetail;
  // final TodoModel todo;
  TodoList(this.tabDetail);
  @override
  State<StatefulWidget> createState() {
    return TodoListState(this.tabDetail);
  }
}

class TodoListState extends State<TodoList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  TodoAppState _currentTodoTitle;
  List<Todo> todoList;
  int count = 0;
  String _tabDetail;
  bool _isChecked = false;
  TodoListState(this._tabDetail);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todoAppState = Provider.of<TodoAppState>(context, listen: false);
    if (todoAppState.currentTodo != null)
      _currentTodoTitle = todoAppState.currentTodo;
    _tabDetail = this._tabDetail;
    todoAppState.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final todoAppState = Provider.of<TodoAppState>(context, listen: true);
    if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
    }

    return Scaffold(
      body: todoList.length != 0 //todoList != null ||
          ? getTodoListView() ?? CircularProgressIndicator()
          : getFromApi() ?? Text('No Todo Available'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showModalBottomSheet(context: context, builder: (context)=>
          //  navigateToDetail(Todo('', '', ''), 'Add Todo'));
          debugPrint('FAB clicked');
          navigateToDetail(Todo('', '', false, ''), 'Add Todo');
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }
  //  onPressed: () {
//             showModalBottomSheet(
//               isScrollControlled: true,
//               context: context,
//               builder: (context) => AddTodos(
// //              addNewTask: addTask,

//                   'Add Todo'),
//             );
//           },
//           child: Icon(Icons.add),
//           foregroundColor: Colors.white,
//         ),

  ListView getFromNetwork() {
    return ListView.builder(
        itemCount: 0,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Calls();
              }));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Breed Name'),
                  subtitle: Text('Breed Description'),
                ),
              ),
            ),
          );
        });
  }

  // ListView getFromApi(TodoAppState todoAppState) {
  //   return ListView.builder(
  //       primary: false,
  //       shrinkWrap: true,
  //       itemCount: todoAppState.getResponseJson().length,
  //       itemBuilder: (BuildContext context, int position) {
  //         return ListTile(
  //           leading: CircleAvatar(
  //             child: Text(
  //                 getFirstLetter(
  //                     todoAppState.getResponseJson()[position]["title"]),
  //                 style: TextStyle(fontWeight: FontWeight.bold)),
  //           ),
  //           title: Text(
  //             todoAppState.getResponseJson()[position]["id"],
  //           ),
  //         );
  //       });
  // }

  FutureBuilder getFromApi() {
    final todoAppState = Provider.of<TodoAppState>(context, listen: true);
    // TodoModelForJson todoListFromJson;
    return FutureBuilder(
        future: todoAppState.fetechTodo(),
        builder: (context, snapshot) {
          final todoLists = snapshot.data;
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int position) {
                //todoListFromJson = snapshot.data;
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Text(getFirstLetter(snapshot.data[position].title),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    title: Text(snapshot.data[position].title + "\n" + "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    subtitle: Text(
                        snapshot.data[position].completed == true
                            ? "Completed task"
                            : "Not Completed",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onTap: () {
                            //_delete(context, todoList[position]);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      debugPrint("ListTile Tapped");
                      //  navigateToDetail(this.todoList[position], 'Edit Todo');
                    },
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.todoList[position].title),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(
                this.todoList[position].title +
                    "\n" +
                    this.todoList[position].date,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            subtitle: Text(this.todoList[position].description,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () {
                    _delete(context, todoList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.todoList[position], 'Edit Todo');
            },
          ),
        );
      },
    );
  }

  ListView getTodoListNewView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: Row(
            children: <Widget>[
              Container(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Text(getFirstLetter(this.todoList[position].title),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  title: Text(
                      this.todoList[position].title +
                          "\n" +
                          this.todoList[position].date,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  subtitle: Text(this.todoList[position].description,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onTap: () {
                          _delete(context, todoList[position]);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    debugPrint("ListTile Tapped");
                    navigateToDetail(this.todoList[position], 'Edit Todo');
                  },
                ),
              ),
              Container(
                  height: 100.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                  ),
                  child: Checkbox(
                      value: this.todoList[position].completed == null
                          ? false
                          : this.todoList[position].completed ?? false,
                      onChanged: (val) {
                        setState(() {
                          _isChecked = val;
                          this.todoList[position].completed = val;
                          // if (val == true) {
                          //   _currText = t;
                          // }
                        });
                      })),
            ],
          ),
        );
      },
    );
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result != 0) {
      _showSnackBar(context, 'Todo Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Todo todo, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TodoDetail(todo, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture =
          databaseHelper.getTodoList(_tabDetail);
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }
}
