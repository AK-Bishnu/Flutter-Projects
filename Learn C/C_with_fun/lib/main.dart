import 'package:c_with_fun/Pages/resultantScreen.dart';
import 'package:flutter/material.dart';

import 'Pages/HomeScreen.dart';
import 'Pages/codeEditorScreen.dart';
import 'Pages/taskPages/printMaster.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: "C Learning Game",
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),

      home: Homescreen(),
    );
  }
}
