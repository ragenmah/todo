import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:todo/database/db_helper.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/notifier/todo_notifier.dart';
import 'package:todo/screens/calls.dart';
import 'package:todo/screens/contacts.dart';
// import 'package:todo/widgets/add_todo.dart';
import 'package:todo/widgets/custom_add_todo.dart';
import 'package:todo/widgets/todo_list.dart';

class Todos extends StatefulWidget {
  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  @override
  void initState() {
    TodoNotifier todoNotifier =
        Provider.of<TodoNotifier>(context, listen: false);
    // getTodo(todoNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.amber,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Your",
                  style: TextStyle(fontSize: 22),
                ),
                Text(
                  "Todos",
                  style: TextStyle(fontSize: 22, color: Colors.green),
                ),
                Container(),
              ],
            ),
          ),
          bottom: TabBar(
            // isScrollable: true,
            // controller: _controller,
            indicatorColor: Colors.white,
            indicatorWeight: 6.0,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(
                child: Text(
                  'ALL',
                  style: TextStyle(color: Colors.white, fontSize: 10.0),
                ),
              ),
              Tab(
                child: Text(
                  'TODAY',
                  style: TextStyle(color: Colors.white, fontSize: 10.0),
                ),
              ),
              Tab(
                child: Text(
                  'TOMORROW',
                  style: TextStyle(color: Colors.white, fontSize: 10.0),
                ),
              ),
              // Text("Today"),
              // Text("Tomorrow"),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  ThemeData.dark();
                  break;

                default:
              }
            },
          ),
        ),
        body: TabBarView(
          // controller: _controller,
          children: [
            TasksList(),
            Text("Today tab"),
            Text("tomorow tab"),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => AddTodos(
//              addNewTask: addTask,

                  'Add Todo'),
            );
          },
          child: Icon(Icons.add),
          foregroundColor: Colors.white,
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ListView(children: [
                  ListTile(
                    title: Text("Todo"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Todos()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text("Contacts"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Contacts()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text("Calls"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Calls()),
                      );
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
        bottomNavigationBar: TitledBottomNavigationBar(
          activeColor: Colors.teal,
          currentIndex: 0,
          onTap: (index) {
            print("selected index : $index");
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Todos()),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Contacts()),
              );
            }
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Calls()),
              );
            }
          },
          items: [
            TitledNavigationBarItem(
              title: 'Todos',
              icon: Icons.list,
              backgroundColor: Colors.grey,
            ),
            TitledNavigationBarItem(
              title: 'Contacts',
              icon: Icons.contacts,
              backgroundColor: Colors.grey,
            ),
            TitledNavigationBarItem(
              title: 'Calls',
              icon: Icons.phone,
              backgroundColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // void navigateToDetail(TodoModel todo, String title) async {
  //   bool result =
  //       await Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return AddTodos(todo, title);
  //   }));

  //   if (result == true) {
  //     updateListView();
  //   }
  // }

  // void updateListView() {
  //   final Future<Database> dbFuture = dbHelper.initializeDatabase();
  //   dbFuture.then((database) {
  //     Future<List<TodoModel>> noteListFuture = dbHelper.gettodoList();
  //     noteListFuture.then((todoList) {
  //       setState(() {
  //         this.todoList = todoList;
  //         this.count = todoList.length;
  //       });
  //     });
  //   });
  // }
}
