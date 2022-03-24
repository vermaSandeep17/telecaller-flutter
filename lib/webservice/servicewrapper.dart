import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:shopify_firebse/utils/CustomException.dart';

class Servicewrapper {
  static var baseurl = "https://www.shopify.blueappsoftware.com/";

  static var mainfolder = "bongosaj/";
  static var apifolder = "app/";
  static var mediafolder = "media/";
  static var indexpage = "index.php/";
  static var securitycode = "123jsnsj@sdfkcn";
  String TAG = "servicewrapper : ";

  var language = "default";

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw Exception(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        throw Exception(response.body.toString());
      default:
        throw FetchDataException(
            'Invalid URL StatusCode : ${response.statusCode}');
    }
  }

  //user login
  Future<Map<String, dynamic>> user_login(String phone, String password) async {
    var responseJson;
    var url = baseurl + mainfolder + apifolder + "user_signin.php";
    final body = {
      'language': language,
      'phone': phone,
      'password': password,
    };
    print(TAG + "user login " + url + "---" + json.encode(body));
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-type': 'application/json;charset=UTF-8',
          'Accept': 'application/json',
          // "X-API-KEY": securitycode
        },
        body: json.encode(body));
    try {
      responseJson = _response(response);
      print(TAG + " userlogin api res " + response.toString());
    } catch (e) {
      print(TAG + 'error userlogin api : $e');
      return responseJson;
    }
    return responseJson;
  }
}
