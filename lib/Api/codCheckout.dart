import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/helper/networkutils.dart';


Future codCheckout(type) async {
  print("wrkibng");


  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');


  Map<String, String> queryParameters = {
    'order_type': type.toString(),
  };

  String queryString = Uri(queryParameters: queryParameters).query;
  final response = await http.get(
    baseUrl+order+ '?' + queryString,
    headers: {"Content-Type": "application/json","Authorization":"token "+token},

  );


  var convertDataToJson = json.decode(response.body.toString());

  return convertDataToJson;
}