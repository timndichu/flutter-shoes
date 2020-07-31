import 'package:coolkicks/models/cart.dart';
import 'package:coolkicks/providers/user-provider.dart';
import 'package:coolkicks/scoped-models/user-model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatefulWidget {
  final Cart shoe;

  CartWidget({this.shoe});

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  int qty = 0;
  int currentPrice = 0;
  int singlePrice = 0;
  String email = '';

  @override
  void initState() {
    qty = widget.shoe.qty;
    singlePrice = widget.shoe.item['price'];
    currentPrice = widget.shoe.price;
    email =
        Provider.of<UserProvider>(context, listen: false).user['user'].email;
    super.initState();
  }

  increment() {
    setState(() {
      qty++;
      currentPrice += singlePrice;

      Provider.of<UserProvider>(context, listen: false).updateTotal(
          currentPrice,
          qty,
          widget.shoe.productId,
          widget.shoe.item['price'],
          widget.shoe.totalQty,
          email);
    });
  }

  decrement() {
    setState(() {
      qty--;
      currentPrice -= singlePrice;

      Provider.of<UserProvider>(context, listen: false).reduceTotal(
          currentPrice,
          qty,
          widget.shoe.productId,
          widget.shoe.item['price'],
          widget.shoe.totalQty,
          email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              color: Colors.red[300],
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                alignment: Alignment.center,
                fit: BoxFit.cover,
                image: AssetImage("assets/nikey.png"),
              ),
            ),
          ),
          SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      width: 100.0,
                      child: Text(
                        '${widget.shoe.item['title']}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  SizedBox(
                    width: 100,
                  ),
                  PopupMenuButton<int>(
                    child: Icon(Icons.more_vert),
                    elevation: 3.2,
                    onSelected: (value) {
                      print(value);
                      if (value == 2) {
                        Map<String, String> body = {
                          "shoeId": '${widget.shoe.productId}',
                          "email": email
                        };
                        print('Remove from Cart');
                        Provider.of<UserProvider>(context, listen: false)
                            .removeFromCart(body)
                            .then((value) => {print(value)});
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text("Add to Favorites"),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text("Remove from cart"),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              Container(
                width: 200.0,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (qty > 1) {
                          decrement();
                          print('The qty is now: $qty');
                        }
                      },
                      color: Colors.red,
                    ),
                    // SizedBox(width: 20.0,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text('$qty'),
                    ),
                    IconButton(
                        iconSize: 20.0,
                        icon: Icon(Icons.add),
                        onPressed: () {
                          increment();
                          print('The qty is now: $qty');
                        },
                        color: Colors.green),

                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        'Ksh. $currentPrice',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
