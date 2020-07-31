
import 'package:coolkicks/models/cart.dart';
import 'package:coolkicks/providers/user-provider.dart';
import 'package:coolkicks/shared/cartWidget.dart';


import 'package:coolkicks/shared/list-tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart-tile.dart';


class CartTotal extends StatelessWidget {
  
  final num totalPrice;
  CartTotal({this.totalPrice});

 
  @override
  Widget build(BuildContext context) {
    print('Total Price is ${totalPrice.toString()}');
   
       return Padding(
         
         padding: const EdgeInsets.all(8.0),
         child: Container(width: 100 ,height: 100.0, color: Colors.red,  child: Text('Total: Ksh. ${totalPrice.toString()}'),),
       );
    
     
    
  }
}