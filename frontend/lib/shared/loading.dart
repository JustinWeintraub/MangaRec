import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/inherited/User.dart';
import 'package:frontend/shared/bottomBar.dart';

class Loading extends StatelessWidget {
  // TODO only option should be logout
  @override
  Widget build(BuildContext context) {
    Widget actions = UserInheritedWidget.of(context).user == null
        ? null
        : bottomBar(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Loading'),
        ),
        body: Container(
            color: Colors.orange[100],
            child: Center(
                child: SpinKitChasingDots(color: Colors.brown, size: 50.0))),
        bottomNavigationBar: actions);
  }
}
