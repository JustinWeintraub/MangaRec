import 'package:flutter/material.dart';
import 'package:frontend/screens/authenticate/login.dart';
import 'package:frontend/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? Login(toggleView: toggleView)
        : Register(toggleView: toggleView);
  }
}
