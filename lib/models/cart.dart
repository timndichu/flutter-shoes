import 'package:coolkicks/models/product.dart';

class Cart {

final String productId;
Map<String, dynamic> item ;
final num qty;
final num price;
final num totalQty;
final num totalPrice;

Cart({this.productId, this.item, this.qty, this.price, this.totalQty, this.totalPrice});

}