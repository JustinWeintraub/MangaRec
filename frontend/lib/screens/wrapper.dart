import 'package:flutter/material.dart';
import 'package:frontend/inherited/User.dart';
import 'package:frontend/screens/authenticate/authentication.dart';
import 'package:frontend/screens/profile.dart';

// TODO: wrapper incomplete

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  dynamic user;
  updateUser(newUser) {
    if (mounted)
      this.setState(() {
        user = newUser;
      });
  }

  Widget updateChild(UserInheritedWidget inherited, Widget child) {
    return new UserInheritedWidget(
        user: inherited.user,
        updateUser: inherited.updateUser,
        child: child,
        updateChild: updateChild);
  }

  @override
  Widget build(BuildContext context) {
    dynamic child = user == null ? Authenticate() : Profile(); //MangaWrapper();

    return new UserInheritedWidget(
        user: user,
        updateUser: updateUser,
        child: child,
        updateChild: updateChild);
  }
}
