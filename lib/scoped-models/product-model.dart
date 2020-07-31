import 'package:scoped_model/scoped_model.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';



mixin ProductsModel on Model {
  List<Product> _products = [];

  List<Product> get products {
    return List.from(_products);
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  final String fetchUrl =
      'https://coolkickske.herokuapp.com/coolkicks/getShoes';

  Future<Null> fetchAllProducts() {
    _isLoading = true;
    notifyListeners();

    return http.get(fetchUrl).then((http.Response response) {
      final List<Product> fetchedProductList = [];

      print(json.decode(response.body));

      final Map<String, dynamic> productListData = json.decode(response.body);

      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData['shoes'].forEach((dynamic productData) {
        final Product product = Product(
          shoeId: productData['_id'].toString(),
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
        );
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
    }).catchError((err)=> print(err));
  }
}
