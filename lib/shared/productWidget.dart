import 'package:coolkicks/models/product.dart';
import 'package:coolkicks/providers/product-provider.dart';

import 'package:coolkicks/shared/list-tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';





class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ShoeTile(shoe: products[index]),
        itemCount: products.length,
      );
    } else {
      productCards = Container();
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return Consumer<ProductProvider> (builder: (context, model, child) {
       return  _buildProductList(model.products);
    }
     
    ,);
  }
}