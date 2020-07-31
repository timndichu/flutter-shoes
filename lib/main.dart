import 'package:coolkicks/providers/product-provider.dart';
import 'package:coolkicks/providers/user-provider.dart';

import 'package:coolkicks/screens/authenticate.dart';

import 'package:coolkicks/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


import 'enum/connectivity_status.dart';

void main() {
   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.deepPurple[700],
    statusBarColor: Colors.deepPurple[700],
  ));
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ProductProvider(),),
      ChangeNotifierProvider(create: (context)=> UserProvider()),
      StreamProvider<ConnectivityStatus>(
     create: (_) => ConnectivityService().connectionStatusController.stream)

    ], child:  MyApp() ,)
    
    
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   
    return 
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
       
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Authenticate(),
      // routes: {
      //   '/' : (BuildContext context) => Authenticate(),
      //   '/homepage' : (BuildContext context) => HomeScreen(),
      //   '/profile' : (BuildContext context) => Profile(),
      //   '/auth' : (BuildContext context) => AuthPage(),
      //   '/login' : (BuildContext context) => Login(),
      //   '/signup' : (BuildContext context) => SignUp(),
      // },
    );
  }
}

