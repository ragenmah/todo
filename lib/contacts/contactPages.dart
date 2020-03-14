import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
// import 'package:todo/contacts/access_contacts.dart';
// import 'package:todo/contacts/contactslist.dart';
import 'package:todo/contacts/mycontacts.dart';
import 'package:todo/screens/contacts_show.dart';
import 'package:todo/screens/todos.dart';
import 'package:todo/widgets/custom_add_todo.dart';
import 'package:todo/widgets/todo_list.dart';
// import '../contacts/addcontacts.dart';
// import 'calls.dart';
import '../contacts/contactsbutton.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:contacts_app/contactsPage.dart';
import '../contacts/contactPages.dart';

import '../screens/calls.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Iterable<Contact> _contacts;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
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
                  "Contacts",
                  style: TextStyle(fontSize: 22, color: Colors.green),
                ),
                Container(),
              ],
            ),
          ),
        ),
        // body: SeeContactsButton(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true, context: context,
              builder: (context) => Text(''),
              //  (context) => AddContacts('Add Contacts'),
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
          currentIndex: 1,
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
        body: _contacts != null
            //Build a list view of all contacts, displaying their avatar and
            // display name
            ? ListView.builder(
                itemCount: _contacts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = _contacts?.elementAt(index);
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                    leading:
                        (contact.avatar != null && contact.avatar.isNotEmpty)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(contact.avatar),
                              )
                            : CircleAvatar(
                                child: Text(contact.initials()),
                                backgroundColor: Theme.of(context).accentColor,
                              ),
                    title: Text(contact.displayName ?? ''),
                    subtitle: Text(contact.emails ?? ''),
                    //This can be further expanded to showing contacts detail
                    // onPressed().
                  );
                },
              )
            : Center(child: const CircularProgressIndicator()),
      ),
    );
  }
}
