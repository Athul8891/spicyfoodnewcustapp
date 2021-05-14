
import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/helper/networkutils.dart';

Future<dynamic>checkuserApi(num)async{
  Map<String, String> queryParameters = {
    'mobile_number': num,
  };

  String queryString = Uri(queryParameters: queryParameters).query;
  var requestUrl =  baseUrl+check + '?' + queryString;
  var response = await http.get(requestUrl);
  var convertDataToJson = json.decode(response.body.toString());
  return convertDataToJson;

}
