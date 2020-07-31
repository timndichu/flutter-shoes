import 'package:coolkicks/providers/product-provider.dart';
import 'package:coolkicks/screens/authenticate.dart';
import 'package:coolkicks/screens/homescreen.dart';
import 'package:coolkicks/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

 final storage = new FlutterSecureStorage();


class MainDrawer extends StatelessWidget {

@override
Widget build(BuildContext context) {
  return Drawer(
    child:
    
     Column(
      children: <Widget>[
        AppBar(automaticallyImplyLeading: false,
        title: Text('Choose'),
        ),
        ListTile(title: Text('View Profile'),
        leading: Icon(Icons.person),
        onTap: () {
           Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => Profile()),
                  );
        },
        ),
         ListTile(title: Text('Home'),
        leading: Icon(Icons.home),
        onTap: () {
           Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => ChangeNotifierProvider(
              create: (context) => ProductProvider(),
              child: HomeScreen(),
            )),
                  );
        },
        ),
          ListTile(title: Text('Log Out'),
        leading: Icon(Icons.exit_to_app),
        onTap: () {
          storage.delete(key: 'token').then((value) => {
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Authenticate()),
                          (Route<dynamic> route) => false,
                        )
                      });
                  
        },
        ),
          

      ],
    ),
  );
}

}


