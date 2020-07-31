

import 'package:coolkicks/providers/product-provider.dart';

import 'package:coolkicks/screens/homescreen.dart';
import 'package:coolkicks/screens/login.dart';
import 'package:coolkicks/screens/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 150.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.deepOrange,
                      onPressed: () {
                        //getData();
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                      padding: const EdgeInsets.all(20.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        color: Colors.purple,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: const EdgeInsets.all(20.0)),
                  ),
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                        color: Colors.grey,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => ChangeNotifierProvider(
              create: (context) => ProductProvider(),
              child: HomeScreen(),
            )),
                          );
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: const EdgeInsets.all(20.0)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
