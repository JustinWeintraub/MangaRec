import 'package:flutter/material.dart';
import 'package:frontend/inherited/User.dart';
import 'package:frontend/shared/bottomBar.dart';
import 'package:frontend/shared/loading/loadingWidget.dart';

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
        body: loadingWidget(),
        bottomNavigationBar: actions);
  }
}
