
import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/helper/networkutils.dart';

Future<dynamic>reviewApi(id,rating)async{
  Map<String, String> queryParameters = {
    'store_id': id,
    'packaging': 'true',
    'rating': rating,
  };

  String queryString = Uri(queryParameters: queryParameters).query;
  var requestUrl =  baseUrl+review + '?' + queryString;
  var response = await http.get(requestUrl);
  var convertDataToJson = json.decode(response.body.toString());
  return convertDataToJson;

}
