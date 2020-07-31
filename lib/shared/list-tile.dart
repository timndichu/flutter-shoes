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
            child: Image.network(
            
  'https://static.nike.com/a/images/t_default/yg04crbgf1kstp6ykpa4/air-max-1-g-golf-shoe-kT60Fh.jpg',
),
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
