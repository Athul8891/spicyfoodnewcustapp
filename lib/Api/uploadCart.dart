import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/helper/networkutils.dart';


Future cartUpload(var storeid,var products) async {
  print("wrkibng");

  var prefs = await SharedPreferences.getInstance();
 var token = prefs.getString('token');
  var strLong = prefs.getString('long');
  var strLat = prefs.getString('lat');
print(token);
  Map<String, String> queryParameters = {
    'lat': strLat,
    'lon': strLong,
  };

  String queryString = Uri(queryParameters: queryParameters).query;
    print([products]);
  final response = await http.post(
    baseUrl+uploadCart+ '?' + queryString,
    headers: {"Content-Type": "application/json","Authorization":"token "+ token},
    body: jsonEncode(<String, dynamic>{
      'location': strLat.toString()+","+strLong.toString(),
      'store_id': int.parse(storeid.toString()),
      'products':products



    }),
  );


  var convertDataToJson = json.decode(response.body.toString());

  return convertDataToJson;
}