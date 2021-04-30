
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/helper/page_transation_fade_animation.dart';
import 'package:zomatoui/resources.dart';

import 'package:zomatoui/screens/login_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zomatoui/screens/fregment_container.dart';

void main() async{

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
   // this.splashMove();
  }



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
          appBarTheme: AppBarTheme(textTheme: TextTheme(headline6: appbar),color: Colors.white,iconTheme: IconThemeData(
              color: Colors.grey[800]
          )),
          textTheme: TextTheme(
              headline6: titleTxt,
              subtitle2: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  letterSpacing: 0.6,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400
              ),
              headline5: appbar,
              button: buttonTxt)),
      home: MyHomePage(title: 'Spicy Food'),
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  //static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PickResult selectedPlace;
  var currentLoc="";

  TextEditingController _edtMobileController = new TextEditingController();
  bool isButtonEnabled=false;
  bool isEmpty(){
    setState(() {
      if(_edtMobileController.text!=" "){
        isButtonEnabled=true;
      }
      else{
        isButtonEnabled=false;
      }
    });
    return isButtonEnabled;
  }
  List gallery = [
    "assets/images/banner_3rd.png",
    "assets/images/banner_ist.png",
    "assets/images/banner_2nd.png",
  ];

  List msg = [
    villageMsg,
    twoMsg,
    threeMsg,
  ];

  @override
  void initState() {
    super.initState();
    this.splashMove();
    this. _getLocation();
  }
  splashMove() async{
    var prefs = await SharedPreferences.getInstance();


    var strKey = prefs.getString('token');

    print(strKey);
    if(strKey != null){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => FragmentContainer()));
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
  @override
  Widget build(BuildContext context) {
    double widthMatch = MediaQuery.of(context).size.width;
    double heightMatch = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 600.0,
            width: widthMatch,
            child: CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 400),
                  enlargeCenterPage: false,
                  aspectRatio: 1 / 2,
                  viewportFraction: 1,
                ),
                itemCount: gallery.length,
                itemBuilder: (BuildContext context, int itemIndex) {
                  return Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: widthMatch,
                          height: heightMatch,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(gallery[itemIndex]),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 16),
                        child: Text(
                          msg[itemIndex],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      )
                    ],
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
                width: widthMatch,
                height: 45,
                child: ElevatedButton(
                  style: eleButton,
                  onPressed: () {
                    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                    //   systemNavigationBarColor: Colors.white, // navigation bar color
                    //   statusBarColor: Colors.white, // status bar color
                    // ));
                    // Navigator.push(context, FadeRoute(page: FragmentContainer()));


                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PlacePicker(
                            apiKey: "AIzaSyBgeYxBAGlhztMLhUW-bH6lUKiU2pY7Lio",
                           // initialPosition: MyHomePage.kInitialPosition,
                            useCurrentLocation: true,
                            selectInitialPosition: true,
                            //usePlaceDetailSearch: true,
                            onPlacePicked: (result) async {
                              selectedPlace = result;
                              print("xoxoxoxo");

                              print(selectedPlace.geometry.location.lat ?? "");
                              print(selectedPlace.geometry.location.lng ?? "");

                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              prefs.setString("long",
                                  selectedPlace.geometry.location.lng.toString());
                              prefs.setString("lat",
                                  selectedPlace.geometry.location.lat.toString());
                              prefs.setString("currentLoc",
                                  selectedPlace.formattedAddress.toString());
                              Navigator.of(context).pop();

                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) =>
                              //             BottomNav()));

                              setState(() {});
                            },
                            //forceSearchOnZoomChanged: true,
                            //automaticallyImplyAppBarLeading: false,
                            //autocompleteLanguage: "ko",
                            //region: 'au',
                            //selectInitialPosition: true,
                            // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                            //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                            //   return isSearchBarFocused
                            //       ? Container()
                            //       : FloatingCard(
                            //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                            //           leftPosition: 0.0,
                            //           rightPosition: 0.0,
                            //           width: 500,
                            //           borderRadius: BorderRadius.circular(12.0),
                            //           child: state == SearchingState.Searching
                            //               ? Center(child: CircularProgressIndicator())
                            //               : RaisedButton(
                            //                   child: Text("Pick Here"),
                            //                   onPressed: () {
                            //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                            //                     //            this will override default 'Select here' Button.
                            //                     print("do something with [selectedPlace] data");
                            //                     Navigator.of(context).pop();
                            //                   },
                            //                 ),
                            //         );
                            // },
                            // pinBuilder: (context, state) {
                            //   if (state == PinState.Idle) {
                            //     return Icon(Icons.favorite_border);
                            //   } else {
                            //     return Icon(Icons.favorite);
                            //   }
                            // },
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    setLocation.toUpperCase(),
                    style: Theme.of(context).textTheme.button,
                  ),

                )),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                haveAnAccount,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              InkWell(
                  onTap: () {
                    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                      systemNavigationBarColor: Colors.white, // navigation bar color
                      statusBarColor: Colors.white, // status bar color
                    ));
                    Navigator.push(context, FadeRoute(page: LoginUI()));
                  },
                  child: Text(
                    "login".toUpperCase(),
                    style: txtButton,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
