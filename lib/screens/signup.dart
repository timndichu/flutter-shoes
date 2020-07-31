
import 'package:coolkicks/shared/NetworkHandler.dart';
import 'package:coolkicks/shared/constants.dart';
import 'package:coolkicks/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String error = '';
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  NetworkHandler networkHandler = NetworkHandler();
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign Up'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              icon: Icon(Icons.person),
              label: Text('Sign In')),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                    controller: _firstname,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Firstname'),
                    validator: (val) =>
                        val.isEmpty ? 'Enter your firstname' : null,
                    onChanged: (val) {
                      setState(() {
                        firstname = val;
                      });
                    }),
                SizedBox(height: 20.0),
                TextFormField(
                    controller: _lastname,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Lastname'),
                    validator: (val) =>
                        val.isEmpty ? 'Enter your lastname' : null,
                    onChanged: (val) {
                      setState(() {
                        lastname = val;
                      });
                    }),
                SizedBox(height: 20.0),
                TextFormField(
                    controller: _email,
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    }),
                SizedBox(height: 20.0),
                TextFormField(
                    controller: _password,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Password'),
                    validator: (val) => val.length < 6
                        ? 'Enter a password 6+ characters long'
                        : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    }),
                SizedBox(height: 20.0),
                loading
                    ? Loading()
                    : RaisedButton(
                        color: Colors.deepOrange,
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            Map<String, String> data = {
                              "firstname": _firstname.text,
                              "lastname": _lastname.text,
                              "email": _email.text,
                              "password": _password.text
                            };
                            setState(() {
                              loading = true;
                            });

                            print(data);
                            networkHandler
                                .post("/coolkicks/register", data)
                                .then((response) => {
                                      setState(() {
                                        loading = false;
                                      }),
                                      if (response['success'])
                                        {
                                          Navigator
                                                        .pushAndRemoveUntil(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (context) =>
                                                              Login()),
                                                      (Route<dynamic> route) =>
                                                          false,
                                                    )
                                        }
                                      else
                                        {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      Text('An Error Occurred'),
                                                  content: Text(response['message']),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('OK'))
                                                  ],
                                                );
                                              })
                                        }
                                    }).catchError((error){
                                       setState(() {
                                                      loading = false;
                                                    });
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      Text('An Error Occurred'),
                                                  content:
                                                      Text('Check your Internet connection then try again'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('OK'))
                                                  ],
                                                );
                                    });
                          });
                          }
                        },
                      ),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
