import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:todo/contacts/mycontacts.dart';
// import 'package:todo/screens/contacts.dart';
import 'package:todo/screens/todos.dart';
import 'package:todo/widgets/custom_add_todo.dart';
import 'package:todo/widgets/todo_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'calls.dart';
import 'dart:io';
// IMPORT PACKAGE
import 'package:call_log/call_log.dart';

import 'contacts_show.dart';

// GET WHOLE CALL LOG

class Calls extends StatefulWidget {
  @override
  _CallsState createState() => _CallsState();
}

class _CallsState extends State<Calls> {
  String _name;
  List<CallLogEntry> _calls;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print('hello');
    _callLogs();
  }

  void _callLogs() async {
    // Iterable<CallLogEntry> entries = await CallLog.get();

    var calls = (await CallLog.get()).toList();

// QUERY CALL LOG (ALL PARAMS ARE OPTIONAL)
    var now = DateTime.now();
    int from = now.subtract(Duration(days: 60)).millisecondsSinceEpoch;
    int to = now.subtract(Duration(days: 30)).millisecondsSinceEpoch;
    Iterable<CallLogEntry> entries1 = await CallLog.query(
      dateFrom: from,
      dateTo: to,
      durationFrom: 0,
      durationTo: 60,
      name: 'Radhika Mam',
      number: '9803601598',
      type: CallType.missed,
    );
    // var _list = entries.toList();
    // print(_list[0].toString());
    setState(() {
      _calls = calls.cast<CallLogEntry>();
    });

    for (var item in calls) {
      print(item.number);
      print(item.name);
      print(item.callType);
      print(item.duration);
      // print(item.timestamp);
      print('\n');

      _name = item.name;
    }
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
                  "Calls",
                  style: TextStyle(fontSize: 22, color: Colors.green),
                ),
                Container(),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: _calls != null
              ? ListView.builder(
                  itemCount: _calls?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    CallLogEntry c = _calls?.elementAt(index);
                    return Card(
                      elevation: 5,
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 120.0,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.teal),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Text(
                                        callTypeCheck(c.callType.toString()),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                    child: Container(
                                      width: 250,
                                      child: Text(
                                        "Name : ${c.name ?? "unknnown Number"}",
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                    child: Container(
                                      width: 100,
                                      child: Text(
                                        c.number ?? "",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        // color: Color.fromARGB(255, 48, 48, 54)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                    child: Container(
                                      width: 100,
                                      child: Text(
                                        "Duration : ${c.duration ?? ""}",
                                        // c.number ?? "",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                        // color: Color.fromARGB(255, 48, 48, 54)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
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
                            child: FlatButton(
                              child: Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                              color: Color.fromRGBO(68, 153, 213, 1.0),
                              shape: CircleBorder(),
                              onPressed: () {
                                launch("tel:${c.number}");
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                    // return ListTile(
                    //   onTap: () {
                    //     // Navigator.of(context).push(MaterialPageRoute(
                    //     //     builder: (BuildContext context) =>
                    //     //         // ContactDetailsPage(c)

                    //     //         ));
                    //   },
                    //   // leading: (c.avatar != null && c.avatar.length > 0)
                    //   //     ? CircleAvatar(backgroundImage: MemoryImage(c.avatar))
                    //   //     : CircleAvatar(child: Text(c.initials())),
                    //   title: Text(c.name ?? ""),
                    //   subtitle: Text(c.number ?? ""),
                    // );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             showModalBottomSheet(
//               isScrollControlled: true,
//               context: context,
//               builder: (context) => AddTodos(
// //              addNewTask: addTask,

//                   'Add Todo'),
//             );
//           },
//           child: Icon(Icons.call),
//           foregroundColor: Colors.white,
//           tooltip: "Make a new call",
//         ),
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
                        MaterialPageRoute(builder: (context) => ContactsShow()),
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
                MaterialPageRoute(builder: (context) => ContactsShow()),
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

  callTypeCheck(String callType) {
    switch (callType) {
      case "CallType.outgoing":
        return "Outgoing Calls";
        break;
      case "CallType.incoming":
        return "incoming Calls";
        break;
      case "CallType.voiceMail":
        return "voiceMail Calls";
        break;
      case "CallType.rejected":
        return "rejected Calls";
        break;
      case "CallType.blocked":
        return "blocked Calls";
        break;
      case "CallType.answeredExternally":
        return "answeredExternally Calls";
        break;
      case "CallType.missed":
        return "missed Call";
        break;
      default:
        return "";
    }
  }
}
