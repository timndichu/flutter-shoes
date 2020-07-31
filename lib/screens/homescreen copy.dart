import 'package:coolkicks/controllers/service.dart';
import 'package:coolkicks/enum/connectivity_status.dart';
import 'package:coolkicks/scoped-models/main-model.dart';
import 'package:coolkicks/screens/authenticate.dart';

import 'package:coolkicks/shared/NetworkHandler.dart';
import 'package:coolkicks/shared/drawer.dart';
import 'package:coolkicks/shared/productWidget.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'dart:async';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final storage = new FlutterSecureStorage();
  var log = Logger();
  NetworkHandler networkHandler = NetworkHandler();
  bool error = false;
  Widget ewidget;

  @override
  void initState() {
    super.initState();

    MainModel model = ScopedModel.of(context);

    model.fetchAllProducts();

    // model.fetchTheUser().catchError((neterror) {
    //   print(neterror);
    //   log.i(neterror);
    //   setState(() {
    //     error = true;
    //   });
    // });
  }

  Widget _buildProductsList() {
    return   
    
    ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No Products Found!'));
        if (model.products.length > 0 && !model.isLoading) {
          content = Products();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
     
        return RefreshIndicator(onRefresh: model.fetchAllProducts, child: content,) ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    if (connectionStatus == ConnectivityStatus.WiFi ||
        connectionStatus == ConnectivityStatus.Cellular) {
      ewidget = ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return _buildProductsList();
        },
      );
    }

    if (connectionStatus == ConnectivityStatus.Offline) {
      ewidget = Center(child: CircularProgressIndicator(),);
    }
    return Scaffold(
        drawer: buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Hi'),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  storage.delete(key: 'token').then((value) => {
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Authenticate()),
                          (Route<dynamic> route) => false,
                        )
                      });
                },
                child: Text('Logout'))
          ],
        ),
        body: ewidget);
  }
}
