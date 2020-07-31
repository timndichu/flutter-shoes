import 'package:coolkicks/shared/cartWidget.dart';
import 'package:flutter/material.dart';

class CartUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
              size: 36.0,
            ),
            onPressed: () {}),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Shopping cart',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21.0),
            ),
            SizedBox(height: 18.0),
            CartWidget(),
          ],
        ),
      ),
    );
  }
}

