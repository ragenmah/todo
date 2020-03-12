import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/notifier/todo_notifier.dart';
// import 'package:todo/screens/ome.dart';
import 'package:todo/screens/home.dart';

import 'notifier/contact_notifier.dart';

void main() => runApp(MyApp());
// MultiProvider(
//     providers: [
//       ChangeNotifierProvider(
//         builder: (context) => TodoNotifier(),
//       ),
//       ChangeNotifierProvider(
//         builder: (context) => ContactNotifier(),
//       ),
//     ],
//     child: MyApp(),
//   ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => TodoNotifier(),
      child: MaterialApp(
        title: 'Your Todos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        builder: (context, child) {
          return Scaffold(
            body: child,
          );
        },
        home: Home(),
      ),
    );
  }
}
