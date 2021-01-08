import 'package:flutter/material.dart';

class UserInheritedWidget extends InheritedWidget {
  const UserInheritedWidget(
      {Key key, this.user, this.updateUser, Widget child, this.updateChild})
      : super(key: key, child: child);

  final dynamic user;
  final Function updateUser;
  final Function updateChild;

  @override
  bool updateShouldNotify(UserInheritedWidget old) {
    print('In updateShouldNotify');
    return user != old.user;
  }

  static UserInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserInheritedWidget>();
  }
}
