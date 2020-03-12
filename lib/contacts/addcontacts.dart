import 'package:flutter/material.dart';

class AddContacts extends StatefulWidget {
  final String actionName;
  AddContacts(this.actionName);
  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  String actionName;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Enter your name',
                labelText: 'Name',
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: 'Enter a phone number',
                labelText: 'Phone',
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.calendar_today),
                hintText: 'Enter your date of birth',
                labelText: 'Dob',
              ),
            ),
            new Container(
                padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                child: new RaisedButton(
                  child: const Text('Submit'),
                  onPressed: null,
                )),
          ],
        ),
      ),
    );
  }
}
