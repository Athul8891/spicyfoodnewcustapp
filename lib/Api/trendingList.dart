import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zomatoui/helper/networkutils.dart';


Future trendingList() async {
  print("wrkibng");



  final response = await http.get(
    baseUrl+trending,
    headers: {"Content-Type": "application/json"},

  );


  var convertDataToJson = json.decode(response.body.toString());

  return convertDataToJson;
}