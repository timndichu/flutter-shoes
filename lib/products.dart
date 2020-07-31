// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:scoped_model/scoped_model.dart';
// import './scoped-models/product-model.dart';
// import 'addproduct.dart';
// import 'models/product.dart';

// class Products extends StatefulWidget {

   

//   @override
//   _ProductsState createState() => _ProductsState();
// }

// class _ProductsState extends State<Products> {

//    @override
//   void initState() {
  
//     super.initState();
//   }


//   Widget _buildProductList(List<Product> products) {
//     Widget productCards;

//     if (products.length > 0) {
//       productCards = ListView.builder(
//           itemCount: products.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(
//                 '${products[index].title})',
//               ),
//               subtitle: Text('${products[index].message}'),
//             );
//           });
//     } else {
//       productCards = Center(
//         child: Container(
//           child: Center(
//             child: Text('Nothing here'),
//           ),
//         ),
//       );
//     }

//     return productCards;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScopedModelDescendant<ProductsModel>(
//         builder: (BuildContext context, Widget child, ProductsModel model) {
//       return Scaffold(
//           appBar: AppBar(
//             title: Text('All Products'),
//             actions: <Widget>[
//               FlatButton( child: Text('Add Post'), onPressed: () {
//                         Navigator.push(context, CupertinoPageRoute(builder: (context)=> AddProduct()));
//                       },
//               )],
//           ),
//           body:
//               SingleChildScrollView(child: _buildProductList(model.products)));
//     });
//   }
// }
