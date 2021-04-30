import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zomatoui/helper/networkutils.dart';


Future customerCreation(var num,var name,var email) async {
  print("wrkibng");



  final response = await http.post(
    baseUrl+register,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(<String, String>{
      'mobile_number': num.toString(),
      'first_name': name.toString(),
      'email': email.toString()



    }),
  );


  var convertDataToJson = json.decode(response.body.toString());

  return convertDataToJson;
}