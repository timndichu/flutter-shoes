import 'package:coolkicks/models/cart.dart';
import 'package:coolkicks/providers/user-provider.dart';
import 'package:coolkicks/shared/cartWidget.dart';

import 'package:coolkicks/shared/list-tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart-tile.dart';

class CartItems extends StatefulWidget {
  @override
  _CartItemsState createState() => _CartItemsState();
}

// class _CartItemsState extends State<CartItems> {
//   Widget _buildProductList(List<Cart> products) {
//     Widget productCards;
//     if (products.length > 0) {
//       productCards = ListView.builder(
//         itemBuilder: (BuildContext context, int index) =>
//             CartTile(shoe: products[index]),
//         itemCount: products.length,
//       );
//     } else {
//       productCards = Container();
//     }
//     return productCards;
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('[Products Widget] build()');
//     return Consumer<UserProvider> (builder: (context, model, child) {
//        return  _buildProductList(model.cart);
//     }

//     ,);
//   }
// }

class _CartItemsState extends State<CartItems> {
  Widget _buildProductList(List<Cart> products) {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: products.length,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (BuildContext context, int index) {
            return CartWidget(
                  shoe: products[index],
                );
            // return Dismissible(
            //     key: UniqueKey(),
            //     direction: DismissDirection.endToStart,
            //     child: CartWidget(
            //       shoe: products[index],
            //     ),
            //     onDismissed: (DismissDirection direction) {
            //       if (direction == DismissDirection.startToEnd) {
            //         print("Add to favorite");
            //       } else {
            //         print('Remove item');
            //       }

            //       setState(() {
            //         products.removeAt(index);
            //       });
            //     },
            //     confirmDismiss: (DismissDirection direction) async {
            //       return await showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return AlertDialog(
            //             title: const Text("Delete Confirmation"),
            //             content: const Text(
            //                 "Are you sure you want to delete this item?"),
            //             actions: <Widget>[
            //               FlatButton(
            //                   onPressed: () => Navigator.of(context).pop(true),
            //                   child: const Text("Delete")),
            //               FlatButton(
            //                 onPressed: () => Navigator.of(context).pop(false),
            //                 child: const Text("Cancel"),
            //               ),
            //             ],
            //           );
            //         },
            //       );
            //     });
          });
    } else {
      productCards = Container();
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return Consumer<UserProvider>(
      builder: (context, model, child) {
        return _buildProductList(model.cart);
      },
    );
  }
}
