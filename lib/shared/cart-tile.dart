import 'package:coolkicks/models/cart.dart';
import 'package:coolkicks/models/product.dart';
import 'package:coolkicks/screens/details.dart';
import 'package:flutter/material.dart';

class CartTile extends StatelessWidget {
  
  final Cart shoe;
  
  CartTile({this.shoe});

  @override
  Widget build(BuildContext context) {
   
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          trailing: Text('Ksh. ${shoe.price.toString()}'),
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage : AssetImage('assets/nike.png')
          ),
          title: Text('${shoe.qty} X ${shoe.item['title']}'),
          subtitle: Text('${shoe.item['description']}'),
         
        ),
      ),
    );
  }
}
