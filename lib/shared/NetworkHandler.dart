import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

class NetworkHandler {
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

  Future<dynamic> post(String url, Map<String, String> body) async {
    url = formatter(url);
    var response = await http.post(url,
        headers: {"Content-type": "application/json"}, body: json.encode(body));

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';

    print(responseData);
    log.d(responseData);

    log.i(responseData);

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
    }

    return {'success': !hasError, 'message': message};

    // log.d(response.statusCode);
    // log.d(response.body);
    //   log.i(response.body);
    //   return [json.decode(response.body), response.statusCode ];
  }

  Future<dynamic> postLogin(String url, Map<String, String> body) async {
    url = formatter(url);

      bool hasError = true;
    String message = 'Something went wrong';
    String token = '';

    var response = await http.post(url,
        headers: {"Content-type": "application/json"}, body: json.encode(body)).catchError((error) {
          return {'message': message + 'Check your Internet connection', 'success' : hasError};
        });

    final Map<String, dynamic> responseData = json.decode(response.body);
  

    print(responseData);
    log.d(responseData);

    log.i(responseData);

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
      token = responseData['token'];
    }
    else {
      message = 'Something went wrong, Check your network';
    }

    return {'success': !hasError, 'message': message, 'token': token};

    // log.d(response.statusCode);
    // log.d(response.body);
    //   log.i(response.body);
    //   return [json.decode(response.body), response.statusCode ];
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

  Future<dynamic> getProfile(String url) async {
    //append url with email that will be extracted from token e.g:   coolkicks/profile/email
    String token = await storage.read(key: 'token');

    Map<String,dynamic> getUser = parseJwt(token);

    String email = getUser['email'];
    String firstname = getUser['firstname'];
    String lastname = getUser['lastname'];
    

    return {email, firstname, lastname};



   

    
  }



  // Future<dynamic> getProfile(String url) async {
  //   //append url with email that will be extracted from token e.g:   coolkicks/profile/email
  //   String token = await storage.read(key: 'token');

  //   Map<String,dynamic> getEmail = parseJwt(token);

  //   String email = getEmail['email'];
    


  //    url = formatter(url+'/$email');
  //   var response = await http.get(url);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
     
  //     Map<String, dynamic> userInfo = json.decode(response.body);

  //     log.i(userInfo);

  //     return userInfo;
  //   }
   

    
  // }
}
