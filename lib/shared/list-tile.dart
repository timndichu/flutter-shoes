import 'package:coolkicks/models/product.dart';
import 'package:coolkicks/screens/details.dart';
import 'package:flutter/material.dart';

class ShoeTile extends StatelessWidget {
  
  final Product shoe;
  
  ShoeTile({this.shoe});

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
          title: Text('${shoe.title}'),
          subtitle: Text('${shoe.description}'),
          onTap: () async {
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DetailsPage(product: shoe)));
          },
        ),
      ),
    );
  }
}
