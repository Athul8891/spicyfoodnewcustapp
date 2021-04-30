import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/helper/networkutils.dart';


Future profile() async {
  print("wrkibng");


  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');





  final response = await http.get(
    baseUrl+profiledata,
    headers: {"Content-Type": "application/json","Authorization":"token "+token},

  );


  var convertDataToJson = json.decode(response.body.toString());
  Map<String, dynamic> map = json.decode(response.body);
  return map;
}