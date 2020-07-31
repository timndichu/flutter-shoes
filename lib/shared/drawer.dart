import 'package:coolkicks/providers/product-provider.dart';
import 'package:coolkicks/screens/authenticate.dart';
import 'package:coolkicks/screens/homescreen.dart';
import 'package:coolkicks/screens/profile.dart';
import 'package:coolkicks/services/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

 final storage = new FlutterSecureStorage();


class MainDrawer extends StatefulWidget {

  @override
  _MainDrawerState createState() => _MainDrawerState();
}




class _MainDrawerState extends State<MainDrawer> {
 bool isDark;
   bool isSwitched ;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
      isDark = Provider.of<ThemeProvider>(context, listen: false).isDark;
    isSwitched = isDark ?? false;


  
  }

   
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

        ListTile(
           leading: Icon(Icons.brightness_6),
          title: Text('Dark Mode'),
          trailing: Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
                ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                themeProvider.swapTheme();
                print(isSwitched);
              });
            },
            activeTrackColor: Colors.lightBlueAccent,
            activeColor: Colors.blue,
          ),
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


