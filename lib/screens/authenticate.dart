import 'package:coolkicks/providers/product-provider.dart';
import 'package:coolkicks/screens/authpage.dart';
import 'package:coolkicks/screens/homescreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final storage = new FlutterSecureStorage();
  var log = Logger();
  bool authenticated = false;

  // void checkToken() async {
  //   String token = await storage.read(key: 'token');
  //   if (token == null || token.length == 0) {
  //     authenticated = false;

  //   } else {
  //     authenticated = true;
  //     print(token);
  //     log.d(token);

  //     log.i(token);

  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //check if Authenticated or Not
    //return either Products Home Screen or Authentication Page
    //If token exists, return Home screen
    //Else return authpage

    return FutureBuilder<String>(
      future: storage.read(key: 'token'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final token = snapshot.data;
          print(token);
          if (token == null || token.length == 0) {
            return AuthPage();
          } else {
            return ChangeNotifierProvider(
              create: (context) => ProductProvider(),
              child: HomeScreen(),
            );
          }
        } else {
          return AuthPage();
        }
      },
    );
  }
}
