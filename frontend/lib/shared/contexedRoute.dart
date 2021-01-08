import 'package:flutter/material.dart';
import 'package:frontend/inherited/User.dart';

Route contexedRoute(context, Widget widget) {
  dynamic userInfo = UserInheritedWidget.of(context);
  return MaterialPageRoute(
      builder: (context) => userInfo.updateChild(userInfo, widget));
}
