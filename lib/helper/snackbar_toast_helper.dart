import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

customSnackBar(BuildContext context, String msg, String action,GlobalKey<ScaffoldState> key,int seconds) {
  final SnackBar snackBar = SnackBar(
    content: Text(msg),
    duration: Duration(seconds: seconds),
    action: SnackBarAction(
        label: action, textColor: Colors.yellow, onPressed: () {}),
  );
  // ignore: deprecated_member_use
  key.currentState.showSnackBar(snackBar);
}

showToastError(String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}


showToastSuccess(String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
  );
}