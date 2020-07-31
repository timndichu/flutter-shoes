import 'package:coolkicks/providers/product-provider.dart';
import 'package:coolkicks/screens/signup.dart';
import 'package:coolkicks/shared/NetworkHandler.dart';
import 'package:coolkicks/shared/constants.dart';
import 'package:coolkicks/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'homescreen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  //Text Field State
  String email = '';
  String password = '';
  String error = '';
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  NetworkHandler networkHandler = NetworkHandler();

  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign In'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
              icon: Icon(Icons.person),
              label: Text('Register')),
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
                    controller: _email,
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
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
                    validator: (val) => val.isEmpty ? 'Enter a password' : null,
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
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            Map<String, String> data = {
                              "email": _email.text,
                              "password": _password.text
                            };
                            setState(() {
                              loading = true;
                            });

                            print(data);
                            networkHandler
                                .postLogin("/coolkicks/login", data)
                                .then((response) => {
                                      if (response['success'])
                                        {
                                          storage
                                              .write(
                                                  key: "token",
                                                  value: response['token'])
                                              .then((value) => {
                                                    setState(() {
                                                      loading = false;
                                                    }),
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (context) =>
                                                            ChangeNotifierProvider(
              create: (context) => ProductProvider(),
              child: HomeScreen(),
            )),
                                                      (Route<dynamic> route) =>
                                                          false,
                                                    )
                                                  })
                                        }
                                      else
                                        {
                                           setState(() {
                                                      loading = false;
                                                    }),
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      Text('An Error Occurred'),
                                                  content:
                                                      Text(response['message']),
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
                          }); }
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
