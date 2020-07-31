import 'package:coolkicks/enum/connectivity_status.dart';
import 'package:coolkicks/models/product.dart';
import 'package:coolkicks/providers/product-provider.dart';
import 'package:coolkicks/providers/user-provider.dart';
import 'package:coolkicks/screens/cart.dart';
import 'package:coolkicks/screens/cartUi.dart';

import 'package:coolkicks/shared/NetworkHandler.dart';
import 'package:coolkicks/shared/drawer.dart';
import 'package:coolkicks/shared/productWidget.dart';
import 'package:coolkicks/shared/searchDelegate.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'dart:async';

import 'package:shimmer/shimmer.dart';

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
  int _currentIndex = 0;
  List<Product> allProducts = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      Provider.of<ProductProvider>(context, listen: false).fetchAllProducts();
    });

    Future.delayed(Duration.zero, () {
      Provider.of<UserProvider>(context, listen: false).fetchTheUser();
    });

    // Provider.of<UserProvider>(context, listen: false).getCart();
  }

  Widget _buildProductsList(context) {
    // var model = Provider.of<ProductProvider>(context);

    return Consumer<ProductProvider>(
      builder: (context, model, child) {
        Widget content = Center(child: Text('No Products Found!'));
        if (model.products.length > 0 && !model.isLoading) {
          content = Products();
          allProducts = model.products;
        } else if (model.isLoading) {
          // content = Center(child: CircularProgressIndicator());
          content = Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: ListView.builder(
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48.0,
                              height: 48.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: 40.0,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      itemCount: 6,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: model.fetchAllProducts,
          child: content,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    if (connectionStatus == ConnectivityStatus.WiFi ||
        connectionStatus == ConnectivityStatus.Cellular) {
      ewidget = Column(children: <Widget>[
        Container(
          height: 60,
          child: Stack(
            fit: StackFit.loose,
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 30,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    }),
              ),
              Positioned(
                  top: 25,
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'COOLKICKS',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w400),
                      ))),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 30,
                    ),
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: DataSearch(products: allProducts));
                    }),
              ),
            ],
          ),
        ),
        Expanded(child: _buildProductsList(context))
      ]);
    }

    if (connectionStatus == ConnectivityStatus.Offline) {
      ewidget = Center(
        child: Text('Check your Internet connection'),
      );
    }

    List<Widget> _children = [
      ewidget,
      Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(children: <Widget>[
            Container(
              height: 60,
              child: Stack(
                fit: StackFit.loose,
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          size: 30,
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        }),
                  ),
                  Positioned(
                      top: 25,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            'COOLKICKS',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w400),
                          ))),
                  Positioned(
                      top: 20,
                      right: 20,
                      child: 
                    
                      IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 30,
                          ),
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: DataSearch(products: allProducts));
                          })),
                ],
              ),
            ),
            Expanded(
                child: Center(
              child: Text('Liked Items'),
            ))
          ])),
      ewidget,
      Cart()
    ];

    return Scaffold(
        key: _scaffoldKey,
       
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.deepPurple,
          buttonBackgroundColor: Colors.transparent,
          index: _currentIndex,
          onTap: onTabTapped,
          backgroundColor: Colors.transparent,
          height: 50,
          animationDuration: Duration(milliseconds: 300),
          items: <Widget>[
            Icon(
              Icons.home,
              color: _currentIndex == 0 ? Colors.deepPurple : Colors.black,
            ),
            Icon(
              Icons.favorite,
              color: _currentIndex == 1 ? Colors.deepPurple : Colors.black,
            ),
            Icon(
              Icons.store_mall_directory,
              color: _currentIndex == 2 ? Colors.deepPurple : Colors.black,
            ),
            Icon(
              Icons.shopping_cart,
              size: 30,
              color: _currentIndex == 3 ? Colors.deepPurple : Colors.black,
            )
          ],
        ),
        drawer: MainDrawer(),
        // appBar: AppBar(
        //   title: Text('Products'),
        //   actions: <Widget>[
        //     FlatButton(
        //         onPressed: () {

        //         },
        //         child: Icon(Icons.search, color: Colors.white))
        //   ],
        // ),
        body: _children[_currentIndex]);
  }
}
