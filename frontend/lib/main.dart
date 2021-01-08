import 'package:flutter/material.dart';
import 'package:frontend/screens/wrapper.dart';

void main() => runApp(MyApp());

const blobTheme = TextStyle(fontSize: 70.0, fontWeight: FontWeight.bold);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(),
      ),
      home: Wrapper(),
    );
  }
}
