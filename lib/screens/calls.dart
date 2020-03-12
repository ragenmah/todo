import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:todo/contacts/mycontacts.dart';
import 'package:todo/screens/contacts.dart';
import 'package:todo/screens/todos.dart';
import 'package:todo/widgets/custom_add_todo.dart';
import 'package:todo/widgets/todo_list.dart';

import 'calls.dart';

class Calls extends StatefulWidget {
  @override
  _CallsState createState() => _CallsState();
}

class _CallsState extends State<Calls> {
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
                  "Calls",
                  style: TextStyle(fontSize: 22, color: Colors.green),
                ),
                Container(),
              ],
            ),
          ),
        ),
        // body: MyContacts(),
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
          currentIndex: 2,
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
}
