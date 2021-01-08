import 'package:flutter/material.dart';
import 'package:frontend/middleware/userware.dart';
import 'package:frontend/shared/constants.dart';
import 'package:frontend/shared/loading.dart';
import 'package:frontend/inherited/User.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String username = '';
  String password = '';
  String error = "";
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.orange[100],
            appBar: AppBar(
              elevation: 0.0,
              title: Text('Sign up to MangaRec'),
              actions: <Widget>[
                FlatButton.icon(
                    icon: Icon(Icons.person),
                    label: Text('Login'),
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
                              val.isEmpty ? 'Enter an username' : null,
                          onChanged: (val) {
                            setState(() => username = val);
                          }),
                      SizedBox(height: 20.0),
                      TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          validator: (val) => !new RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
                                  .hasMatch(val)
                              ? 'The password needs to be at least 8 characters long, have one upper case and lower case number, and a number.'
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          }),
                      SizedBox(height: 20.0),
                      TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Validate password'),
                          validator: (String val) => val != password
                              ? 'Passwords have to match.'
                              : null),
                      SizedBox(height: 20.0),
                      RaisedButton(
                          color: Colors.blue[400],
                          child: Text('Register',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                                  await Userware().register(username, password);
                              if (result['success'] == false)
                                setState(() => {
                                      loading = false,
                                      error = result['message']
                                    });
                              else
                                widget.toggleView();
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
