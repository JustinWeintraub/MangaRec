import 'package:flutter/material.dart';
import 'package:frontend/middleware/userware.dart';
import 'package:frontend/shared/constants.dart';
import 'package:frontend/shared/loading/loadingPage.dart';
import 'package:frontend/inherited/User.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //text field state
  String username = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.orange[100],
            appBar: AppBar(
              elevation: 0.0,
              title: Text('Sign in to MangaRec'),
              actions: <Widget>[
                FlatButton.icon(
                    icon: Icon(Icons.person),
                    label: Text('Register'),
                    onPressed: () {
                      widget.toggleView();
                    })
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Username'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter a username' : null,
                          onChanged: (val) => setState(() => username = val)),
                      SizedBox(height: 20.0),
                      TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          //decoration: textInputDecoration.copyWith(hintText: 'Password'),
                          validator: (val) => !new RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
                                  .hasMatch(val)
                              ? 'The password needs to be at least 8 characters long, have one upper case and lower case number, and a number.'
                              : null,
                          onChanged: (val) => setState(() => password = val)),
                      SizedBox(height: 20.0),
                      RaisedButton(
                          color: Colors.blue[400],
                          child: Text('Sign in',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                                  await Userware().login(username, password);
                              if (result['success'] == false && mounted)
                                setState(() => {
                                      loading = false,
                                      error = result['message']
                                    });
                              else
                                UserInheritedWidget.of(context)
                                    .updateUser(result);
                            }
                          }),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  ),
                )),
          );
  }
}
