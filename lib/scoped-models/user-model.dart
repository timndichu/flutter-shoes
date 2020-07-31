import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/userData.dart';

mixin UserModel on Model {
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

  Future<dynamic> getProfile() async {
    //append url with email that will be extracted from token e.g:   coolkicks/profile/email
    String token = await storage.read(key: 'token');

    Map<String, dynamic> getEmail = parseJwt(token);

    String email = getEmail['email'];
    Map<String, dynamic> userInfo;

    String url = formatter('/coolkicks/profile/$email');
    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      userInfo = json.decode(response.body);

      log.i(userInfo);

      return userInfo;
    }
    else {
       userInfo = json.decode(response.body);

      log.i(userInfo);

      return userInfo;
    }

  
  }

   Future<dynamic> updateCart(int currentPrice, int qty) async {
    

  }

  Future<dynamic> fetchTheUser() async {
    final Map<String, User> fetchedUser = {};

    if (_user.isEmpty) {
      _isLoading = true;
      notifyListeners();
      final Map<String, dynamic> userData = await getProfile().catchError((error)=> {
        _isLoading = true
      });

      final theUser = User(
        firstname: userData['firstname'],
        lastname: userData['lastname'],
        email: userData['email'],
      );
      fetchedUser['user'] = theUser;
      _user = fetchedUser;
      _isLoading = false;
      notifyListeners();
    } else {
      _user = _user;
      notifyListeners();
    }
  }

 


 

}
