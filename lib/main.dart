import 'package:flutter/material.dart';

import './home_menu.dart';
import './create_data.dart';

void main() {
  runApp(
    MaterialApp(
     theme: ThemeData(
        primaryColor: Colors.blueGrey,
        accentColor: Colors.white,
        textTheme: ThemeData.light().textTheme.copyWith(
              body1: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.blueGrey,
              ),
              body2: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey,
                  height: 1.5),
            ),
      ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Courses Student Data",
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.playlist_add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddScreen(),
                    ));
              }),
        ],
      ),
      body: HomeScreen(),
    );
  }
}
