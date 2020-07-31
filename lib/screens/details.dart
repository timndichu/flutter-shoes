import 'package:coolkicks/models/product.dart';
import 'package:coolkicks/providers/product-provider.dart';
import 'package:coolkicks/providers/user-provider.dart';
import 'package:coolkicks/screens/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  final Product product;
  DetailsPage({this.product});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> user =
        Provider.of<UserProvider>(context, listen: false).user;
    Map<String, String> data;
    if (user.isNotEmpty) {
      data = {
        "shoeId": widget.product.shoeId,
        "shoeSize": "17",
        "email": user['user'].email
      };
    }

    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Details'),
        ),
        body: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              child: ListTile(
                trailing: Text('Ksh. ${widget.product.price.toString()}'),
                leading: CircleAvatar(
                    radius: 25.0,
                    backgroundImage: AssetImage('assets/nike.png')),
                title: Text(widget.product.title),
                subtitle: Text(widget.product.description),
              ),
            ),
            SizedBox(height: 50.0),
            Consumer<ProductProvider>(builder: (context, model, child) {
              return loading
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      child: Text('Add to Cart'),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        if (user.isEmpty) {
                          setState(() {
                            loading = false;
                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('It seems You like this item'),
                                  content: Text('Please Login to Add to Cart'),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'))
                                  ],
                                );
                              });
                          return print('Login to add to cart');
                        } else {
                          return model
                              .addToCart(data)
                              .then((value) => {
                                    setState(() {
                                      loading = false;
                                    }),
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => Cart()))
                                  })
                              .catchError((err) {
                            print(err);
                          });
                        }
                      });
            })
          ],
        ));
  }
}
