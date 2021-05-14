import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/Api/FirebaseApi.dart';
import 'package:zomatoui/helper/snackbar_toast_helper.dart';
import 'package:zomatoui/resources.dart';
import 'package:flutter/material.dart';

import 'fregment_container.dart';
import 'login_ui.dart';

class AddAddressUIStart extends StatefulWidget {
  @override
  _AddAddressUIState createState() => _AddAddressUIState();
}

class _AddAddressUIState extends State<AddAddressUIStart> {


  var tap = false;
  var currentLoc="";
  var currentLat="";
  var currentLon="";
  var subcurrentLoc="";
  PickResult selectedPlace;
  TextEditingController unitController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  GlobalKey<GoogleMapStateBase> _key = GlobalKey<GoogleMapStateBase>();

  @override
  void initState() {
this. _getLocation();

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
      currentLon= currentLocation.longitude.toString();
      currentLat= currentLocation.latitude.toString();
      print("lon");
      print(currentLon);

      print("lat");
      print(currentLat);
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

              currentLoc = currentLoc;
              subcurrentLoc = placemark[0].subLocality.toString();
           //   prefs.setString("currentLoc", currentLoc.toString());


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
    return Scaffold(
      body:currentLat==""?  Center(child: CircularProgressIndicator())
        : SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: (){
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
                                setState(() {
                                  currentLat=  selectedPlace.geometry.location.lat.toString();
                                  currentLon=selectedPlace.geometry.location.lng.toString();
                                  currentLoc=selectedPlace.formattedAddress.toString();
                                });



                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => FragmentContainer()));


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
                    child: GoogleMap(
                      key: _key,
                      initialPosition:  GeoCoord(double.parse(currentLat.toString()), double.parse(currentLon.toString())),
                      onTap: null,

                      markers: {
                        Marker(
                          GeoCoord(double.parse(currentLat.toString()), double.parse(currentLon.toString())),
                        ),
                      },

                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.pin_drop_outlined,
                        size: 20,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        currentLoc,
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.6,
                            color: Color(0xff333333),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold),
                      ),

                    ],



                  ),
                  Text(
                    subcurrentLoc,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),

                  SizedBox(
                    height: 10,
                  ),


                  SizedBox(
                    width: 80,
                    height: 25,
                    child: ElevatedButton(
                      style: eleButton,
                      onPressed: () async {
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
                                  setState(() {
                                    currentLat=  selectedPlace.geometry.location.lat.toString();
                                    currentLon=selectedPlace.geometry.location.lng.toString();
                                    currentLoc=selectedPlace.formattedAddress.toString();
                                    print("currentLoc");
                                    print(currentLoc);
                                  });
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

                        "Change",

                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 47.8,
                    child: TextField(
                      controller: unitController,
                      decoration: InputDecoration(
                        hintText: "Flat/House/block no".toUpperCase(),
                        hintStyle: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 47.8,
                    child: TextField(
                      controller: landmarkController,
                      decoration: InputDecoration(
                        hintText: "landmark".toUpperCase(),
                        hintStyle: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    child: ElevatedButton(
                      style: eleButton,
                      onPressed: () async {
                        setState(() {
                          tap=true;
                        });
                        var rsp =await addAdd(currentLat,currentLon,currentLoc,landmarkController.text.toString(),unitController.text.toString(),currentLoc.toString());
                        if(rsp=="SUCCESS"){
                          showToastSuccess("Address added sucssesfully");

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("long",
                             currentLon.toString());
                          prefs.setString("lat",
                              currentLat.toString());
                          prefs.setString("currentLoc",
                             currentLoc.toString());
                         // Navigator.pop(context);


                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => FragmentContainer()));
                         //  Navigator.pushReplacement(
                         //      context,
                         //      MaterialPageRoute(
                         //          builder: (BuildContext context) =>
                         //              LoginUI()));
                        }else{
                          showToastError("Failed to add!");

                          setState(() {
                            tap=false;
                          });

                        }
                        print("adresssss");
                        print(rsp);
                        // SharedPreferences prefs =
                        //     await SharedPreferences.getInstance();
                        // prefs.setString("long",
                        //     selectedPlace.geometry.location.lng.toString());
                        // prefs.setString("lat",
                        //     selectedPlace.geometry.location.lat.toString());
                        // prefs.setString("currentLoc",
                        //     selectedPlace.formattedAddress.toString());

                      },
                      child: Text(tap==true?"SAVING...":
                        "save and proceed".toUpperCase(),
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
