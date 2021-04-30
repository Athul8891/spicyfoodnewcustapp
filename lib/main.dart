import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/resources.dart';
import 'package:zomatoui/screens/InitialPage.dart';
import 'package:zomatoui/screens/fregment_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    routes: <String, WidgetBuilder>{},
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   // this.splashMove();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comida',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: accentColor,
          buttonColor: accentColor,
          accentColor: accentColor,
          appBarTheme: AppBarTheme(
              textTheme: TextTheme(headline6: appbar),
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.grey[800])),
          textTheme: TextTheme(
              headline6: titleTxt,
              subtitle2: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  letterSpacing: 0.6,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400),
              headline5: appbar,
              button: buttonTxt)),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
    _loadWidget();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: Center(
          child: Image(
            image: AssetImage("assets/images/splash.jpg"),
            height: MediaQuery.of(context).size.height * 3,
          ),
        ),
      ),
    );
  }

  _loadWidget() async {
    var _duration = Duration(seconds: 4);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    var prefs = await SharedPreferences.getInstance();

    var strKey = prefs.getString('token');

    print(strKey);
    if (strKey != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => FragmentContainer()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => InitialPage()));
    }
  }
}
