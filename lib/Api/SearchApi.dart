
import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/helper/networkutils.dart';

Future<dynamic>searchApi(data)async{

  var prefs = await SharedPreferences.getInstance();



  var strLong = prefs.getString('long');
  var strLat = prefs.getString('lat');
  Map<String, String> queryParameters = {
    'data': data.toString(),
    'lat': strLat.toString(),
    'lon': strLong.toString(),
  };

  String queryString = Uri(queryParameters: queryParameters).query;
  var requestUrl =  baseUrl+search + '?' + queryString;
  var response = await http.get(requestUrl);
  var convertDataToJson = json.decode(response.body.toString());
  //Map<String, dynamic> map = json.decode(response.body);
  return convertDataToJson;

}
