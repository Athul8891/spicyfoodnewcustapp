import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/helper/networkutils.dart';


Future profile(id) async {
  Map<String, String> queryParameters = {
    'order_id': id,

  };

  String queryString = Uri(queryParameters: queryParameters).query;
  var requestUrl =  baseUrl+orderstatus + '?' + queryString;
  var response = await http.get(requestUrl);
  var convertDataToJson = json.decode(response.body.toString());
  return convertDataToJson;
}