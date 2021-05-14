
import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/helper/networkutils.dart';

Future<dynamic>storeNearApi()async{
  // var endpointUrl = 'https://v.3multi.qgrocer.in/public/api/signup';
  var prefs = await SharedPreferences.getInstance();



   var strLong = prefs.getString('long');
  var  strLat = prefs.getString('lat');

  print("strLong");
  print(strLong);
  print("strLat");
  print(strLat);
    // id = prefs.getString('lat');
  //    strLat="10.023286";
  // strLong="76.311371";

  Map<String, String> queryParameters = {
    'lat': strLat,
    'lon': strLong,
    'store_type': "restaurant",
  };

  String queryString = Uri(queryParameters: queryParameters).query;
  var requestUrl =  baseUrl+stores + '?' + queryString;
  var response = await http.get(requestUrl);
  var convertDataToJson = json.decode(response.body.toString());
  return convertDataToJson;

}
