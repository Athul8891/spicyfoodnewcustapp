
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/Api/FirebaseApi.dart';
import 'package:zomatoui/helper/page_transation_fade_animation.dart';
import 'package:zomatoui/helper/snackbar_toast_helper.dart';
import 'package:zomatoui/resources.dart';
import 'package:flutter/material.dart';

import 'add_address_ui.dart';

class ManageAddress extends StatefulWidget {
  final title;

  ManageAddress({this.title});

  @override
  _ManageAddressState createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  var cartItems=[];

  @override
  void initState() {
    this. getAllCartItems();
  }
  void  getAllCartItems()async{
    cartItems.clear();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final User user = firebaseAuth.currentUser;
    final uid = user.uid;

    FirebaseFirestore.instance.collection("address").doc(uid).collection(uid)
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        // print("doc");
        setState(() {

          cartItems.add({'id': doc.reference.toString(),'adress': doc.get('adress'),'landmark': doc.get('landmark'),'lat': doc.get('lat'),'long': doc.get('long'),'unit': doc.get('unit'),  });
        });
      })
    }).whenComplete(()async{



    });







  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: appbar,
        ),
        elevation: 1,
        actions: [
          IconButton(icon: Icon(Icons.add_location_alt,size: 18,), onPressed: (){
            Navigator.push(
              context,
              FadeRoute(
                page: AddAddressUI(),
              ),
            );
          }),
          SizedBox(width: 8,),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            color: Colors.blueGrey[50].withOpacity(0.98),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    saveAddress.toUpperCase(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
           // itemCount: 2,
            padding: EdgeInsets.only(top:12.0),
            itemCount: cartItems != null ? cartItems.length : 0,
            itemBuilder: (context, index) {
              final item  = cartItems != null ? cartItems[index] : null;
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.home_outlined,
                      size: 22,
                    ),
                    SizedBox(width: 16,),
                    Expanded(
                      flex:1,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['unit'].toString(),
                              style: titleBold,
                            ),
                            Text(
                              item['adress'].toString() +"\n"+item['landmark'].toString(),
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 30,
                                  child: TextButton(
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                      prefs.setString("long",
                                          item['long'].toString());
                                      prefs.setString("lat",
                                          item['lat'].toString());
                                      prefs.setString("currentLoc",
                                          item['adress'].toString());

                                      // Navigator.push(
                                      //   context,
                                      //   FadeRoute(
                                      //     page: AddAddressUI(),
                                      //   ),
                                      // );
                                    },
                                    child: Text(
                                      "SET AS DEFAULT",
                                      style: TextStyle(color: Colors.deepOrange),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 30,
                                  child: TextButton(
                                    onPressed: ()async {
                                     var rsp = dltAdd(item['id'].toString());
                                     
                                     if(rsp == "SUCCESS"){
                                       showToastSuccess("Successfully removed");
                                       getAllCartItems();
                                     }else{
                                       
                                     }

                                    },
                                    child: Text(
                                      "DELETE",
                                      style: TextStyle(color: Colors.deepOrange),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(height: 2,),
                            Divider()
                          ]
                      ),),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }


}
