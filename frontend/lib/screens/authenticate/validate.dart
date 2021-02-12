import 'package:flutter/material.dart';
import 'package:frontend/inherited/User.dart';
import 'package:frontend/middleware/userware.dart';
import 'package:frontend/shared/constants.dart';

class Validate extends StatefulWidget {
  final String username;
  final String password;
  final Function toggleView;

  Validate({this.username, this.password, this.toggleView});

  @override
  _ValidateState createState() => _ValidateState();
}

class _ValidateState extends State<Validate> {
  final formKey = GlobalKey<FormState>();
  String code = '';
  String error = '';
  bool loading = false;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Validate Account'),
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
              key: formKey,
              child: Column(children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Code'),
                    validator: (val) =>
                        val.isEmpty ? 'Enter a valid code' : null,
                    onChanged: (val) => setState(() => code = val)),
                SizedBox(height: 20.0),
                RaisedButton(
                    color: Colors.blue[400],
                    child:
                        Text('Sign in', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        // TODO
                        setState(() => loading = true);
                        dynamic result = await Userware()
                            .validate(widget.username, widget.password, code);
                        if (mounted) {
                          if (result['success'] == false)
                            setState(() =>
                                {loading = false, error = result['message']});
                          else {
                            UserInheritedWidget.of(context).updateUser(result);
                          }
                        }
                      }
                    }),
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ]))),
    );
  }
}
