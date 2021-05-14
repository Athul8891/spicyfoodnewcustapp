import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/resources.dart';
import 'package:zomatoui/screens/InitialPage.dart';
import 'package:zomatoui/screens/fregment_container.dart';

void main() async {
  GoogleMap.init('AIzaSyCE-qGbzGnzeI5P_2MgdMQ6-0eMyLzz9TA');
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
  @override
  void initState() {
     // this._g();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spicyy Food',
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
  PickResult selectedPlace;
  var currentLoc="";

  @override
  void initState() {
    super.initState();
    _loadWidget();
  _getLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image(
            image: AssetImage("assets/images/splash.png"),
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

  _getLocation() async {

    try {
      Geolocator geolocator = Geolocator();
      Position currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
          currentLocation.latitude, currentLocation.longitude);
      ///
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("long", currentLocation.longitude.toString());
      prefs.setString("lat", currentLocation.latitude.toString());
      ///
      if (currentLocation != null) {
        print("country : ${placemark[0].country}");
        print("position : ${placemark[0].position}");
        print("locality : ${placemark[0].locality}");
        print("administrativeArea : ${placemark[0].administrativeArea}");
        print("postalCode : ${placemark[0].postalCode}");
        print("name : ${placemark[0].name}");
        print("subAdministrativeArea : ${placemark[0].subAdministrativeArea}");
        print("isoCountryCode : ${placemark[0].isoCountryCode}");
        print("subLocality : ${placemark[0].subLocality}");
        print("subThoroughfare : ${placemark[0].subThoroughfare}");
        print("thoroughfare : ${placemark[0].thoroughfare}");

        if (placemark[0] != null) {
          if (placemark[0].country.isNotEmpty) {}

          if (placemark[0].administrativeArea.isNotEmpty) {}

          if (placemark[0].subAdministrativeArea.isNotEmpty) {}

          if (placemark[0].name.isNotEmpty) {
            setState(() {
              currentLoc = placemark[0].name.toString();
            });
          }
          if (placemark[0].postalCode.isNotEmpty) {}
          if (placemark[0].name.isNotEmpty) {}
          if (placemark[0].subLocality.isNotEmpty) {
            setState(() {
              currentLoc = currentLoc+","+placemark[0].subLocality.toString();
              prefs.setString("currentLoc", currentLoc.toString());


            });
          }
          if (placemark[0].locality.isNotEmpty) {}
        }


      }


    } on PlatformException catch (error) {
      print(error.message);
    } catch (error) {
      print("Error: $error");
    }


  }
}
