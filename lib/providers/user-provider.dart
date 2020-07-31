import 'package:coolkicks/models/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/userData.dart';

class UserProvider extends ChangeNotifier {
  List<Cart> _cart = [];

  num _totalPrice = 0;

  num get totalPrice {
    return _totalPrice;
  }

  List<Cart> get cart {
    return List.from(_cart);
  }

  Map<String, User> _user = {};

  Map<String, User> get user {
    return Map.from(_user);
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  String baseurl = "https://coolkickske.herokuapp.com";
  var log = Logger();
  final storage = new FlutterSecureStorage();

  String formatter(String url) {
    return baseurl + url;
  }

  Future get(String url) async {
    url = formatter(url);
    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Map<String, dynamic> parseJwt(String token) {
    String _decodeBase64(String str) {
      String output = str.replaceAll('-', '+').replaceAll('_', '/');

      switch (output.length % 4) {
        case 0:
          break;
        case 2:
          output += '==';
          break;
        case 3:
          output += '=';
          break;
        default:
          throw Exception('Illegal base64url string!"');
      }

      return utf8.decode(base64Url.decode(output));
    }

    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  Future getProfile() async {
    //append url with email that will be extracted from token e.g:   coolkicks/profile/email
    String token = await storage.read(key: 'token');
    Map<String, dynamic> userInfo = {};

    if (token == null) {
      return userInfo;
    }

    if (token.length != 0 || token != null) {
      Map<String, dynamic> getEmail = parseJwt(token);

      String email = getEmail['email'];

      String url = formatter('/coolkicks/profile/$email');
      var response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        userInfo = json.decode(response.body);

        log.i(userInfo);

        return userInfo;
      } else {
        userInfo = json.decode(response.body);

        log.i(userInfo);

        return userInfo;
      }
    }
  }

  Future fetchTheUser() async {
    Map<String, User> fetchedUser = {};
    final List<Cart> fetchedCart = [];

    // if (_user.isEmpty) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> userData =
        await getProfile().catchError((error) => {});

    if (userData.isEmpty) {
      _user = fetchedUser;
      _isLoading = false;
      notifyListeners();
    } else {
      final theUser = User(
          firstname: userData['firstname'],
          lastname: userData['lastname'],
          email: userData['email'],
          cart: userData['cart']);
      fetchedUser['user'] = theUser;
      _user = fetchedUser;

      final Map<String, dynamic> cartData = userData['cart'];

      _totalPrice = cartData['totalPrice'];

      cartData['items'].forEach((dynamic cartItem) {
        final Cart cart = Cart(
            productId: cartItem['productId'],
            item: cartItem['item'],
            qty: cartItem['qty'],
            price: cartItem['price'],
            totalPrice: cartData['totalPrice'],
            totalQty: cartData['totalQty']);

        fetchedCart.add(cart);
      });
      _cart = fetchedCart;
      _isLoading = false;
      notifyListeners();
    }
    // } else {

    //   _user = _user;
    //   notifyListeners();
    // }
  }

  Future updateTotal(
    int currentPrice,
    int qty,
    String productId,
    int singlePrice,
    int totalQty,
    String email
  ) async {
    _isLoading = true;
    notifyListeners();

    _totalPrice += singlePrice;

    _isLoading = false;

      String url = 'https://coolkickske.herokuapp.com/coolkicks/updateCart';

     Map<String, String> body = {
                          "shoeId": productId,
                          "shoePrice": singlePrice.toString(),
                          "email": email
                        };


    var response = await http.post(url,
        headers: {"Content-type": "application/json"}, body: json.encode(body));

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';

    if (responseData['statusCode'] == '403') {
      hasError = true;
      message = responseData['msg'];
    } else if (responseData['statusCode'] == '401' ||
        responseData['statusCode'] == '500') {
      hasError = true;
      message = responseData['msg'];
    } else if (responseData['statusCode'] == '200') {
      hasError = false;
      message = responseData['msg'];

      //Handle response which is a cart
      final Map<String, dynamic> cartData = responseData['cart']['cart'];
      log.i(cartData);
    notifyListeners();

    }

  }

  Future reduceTotal(
    int currentPrice,
    int qty,
    String productId,
    int singlePrice,
    int totalQty,
    email
  ) async {
    _isLoading = true;
    notifyListeners();

    _totalPrice -= singlePrice;

    _isLoading = false;

      String url = 'https://coolkickske.herokuapp.com/coolkicks/reduceCart';

     Map<String, String> body = {
                          "shoeId": productId,
                          "shoePrice": singlePrice.toString(),
                          "email": email
                        };


    var response = await http.post(url,
        headers: {"Content-type": "application/json"}, body: json.encode(body));

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';

    if (responseData['statusCode'] == '403') {
      hasError = true;
      message = responseData['msg'];
    } else if (responseData['statusCode'] == '401' ||
        responseData['statusCode'] == '500') {
      hasError = true;
      message = responseData['msg'];
    } else if (responseData['statusCode'] == '200') {
      hasError = false;
      message = responseData['msg'];

      //Handle response which is a cart
      final Map<String, dynamic> cartData = responseData['cart']['cart'];
      log.i(cartData);
    notifyListeners();

    }


    notifyListeners();
  }

  Future removeFromCart(Map<String, String> body) async {
    final List<Cart> fetchedCart = [];
    _cart = fetchedCart;
    _isLoading = true;
    notifyListeners();
    String url = 'https://coolkickske.herokuapp.com/coolkicks/removeFromCart';

    var response = await http.post(url,
        headers: {"Content-type": "application/json"}, body: json.encode(body));

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';

    if (responseData['statusCode'] == '403') {
      hasError = true;
      message = responseData['msg'];
    } else if (responseData['statusCode'] == '401' ||
        responseData['statusCode'] == '500') {
      hasError = true;
      message = responseData['msg'];
    } else if (responseData['statusCode'] == '200') {
      hasError = false;
      message = responseData['msg'];

      //Handle response which is a cart
      final Map<String, dynamic> cartData = responseData['cart']['cart'];
      _totalPrice = cartData['totalPrice'];
      cartData['items'].forEach((dynamic cartItem) {
        final Cart cart = Cart(
            productId: cartItem['productId'],
            item: cartItem['item'],
            qty: cartItem['qty'],
            price: cartItem['price'],
            totalPrice: cartData['totalPrice'],
            totalQty: cartData['totalQty']);

        fetchedCart.add(cart);
      });
      _cart = fetchedCart;
      _isLoading = false;
      notifyListeners();
    }

    return {'success': !hasError, 'message': message};
  }

  Future getToken() async {
    //append url with email that will be extracted from token e.g:   coolkicks/profile/email
    String token = await storage.read(key: 'token');

    print(token);
  }
}
