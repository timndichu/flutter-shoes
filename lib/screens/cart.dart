import 'package:coolkicks/providers/user-provider.dart';
import 'package:coolkicks/screens/homescreen.dart';
import 'package:coolkicks/shared/cartItems.dart';
import 'package:coolkicks/shared/cartTotal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'homescreen.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  ScrollController _controller = new ScrollController();
  Widget itemsWidget;
  Widget totalsWidget;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Provider.of<UserProvider>(context, listen: false).fetchTheUser();
    });
    return Scaffold(
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {},
      //   isExtended: true,
      //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

      //   label: Text('Total: KSh.5000 Checkout'),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
              size: 36.0,
            ),
            onPressed: () {
               Navigator.pop(context);
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<UserProvider>(
          builder: (context, model, child) {
            if ((model.user.length > 0 &&
                !model.isLoading &&
                model.cart.length > 0)) {
              itemsWidget = Expanded(
                child: CartItems(),
              );

              totalsWidget = FloatingActionButton.extended(
                onPressed: () {},
                isExtended: true,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                label: Text('Total: Ksh. ${model.totalPrice}. CHECKOUT'),
              );
            } else if ((model.user.length > 0 &&
                !model.isLoading &&
                model.cart.length == 0)) {
              itemsWidget = Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 150),
                      Container(
                        child: Text(
                          'Nothing in the cart.',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => HomeScreen()));
                        },
                        isExtended: true,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        label: Text('Continue Shopping'),
                      )),
                    ],
                  ),
                ),
              );

              totalsWidget = Container();
            } else if (model.isLoading) {
              itemsWidget =
                  Center(heightFactor: 10, child: CircularProgressIndicator());
              totalsWidget = Container();
            } else {
              itemsWidget = Center(child: Text('Please Login to View Cart'));
              totalsWidget = Center(child: Text('Please Login to View Cart'));
            }
            return Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Shopping cart',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 21.0),
                    ),
                    SizedBox(height: 18.0),
                    itemsWidget,
                    SizedBox(height: 50.0),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: totalsWidget,
                )
              ],
            );
          },
        ),
      ),
    );

    // Scaffold(
    //   appBar: AppBar(
    //     actions: <Widget>[],
    //     title: Text('Cart'),
    //   ),
    //   body:
    //   Consumer<UserProvider>(
    //     builder: (context, model, child) {
    //       if((model.user.length > 0 && !model.isLoading) ) {
    //           return CartItems();
    //       }
    //       else if (model.isLoading) {
    //         return Center(child: CircularProgressIndicator());
    //       }
    //       else{
    //         return Center(child: Text('Please Login to View Cart'));
    //       }

    //     },
    //   ),
    // );
  }
}
