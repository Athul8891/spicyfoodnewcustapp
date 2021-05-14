import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_id/device_id.dart';

Future addToCart(varient_id,store_id,quantity,productid,storeid) async {


 print("varient_id");
 print(varient_id);
 print(store_id);
 print(quantity);

  var prefs = await SharedPreferences.getInstance();
//  var device_id = prefs.getString('token');

  var strLong = prefs.getString('long');
  var strLat = prefs.getString('lat');
  var currentStore = prefs.getString('store');
  print("currentStore");
  print(currentStore);


 final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
 final User user = firebaseAuth.currentUser;
 final uid = user.uid;
  var rslt = "WORKING";

  if(currentStore==null||currentStore==storeid){
    await  FirebaseFirestore.instance.collection("cart").doc(uid).collection(store_id).doc(varient_id).set(
        {
          // "id": uid.toString(),
          "lat":strLat,
          "long":strLong,
          "store_id":store_id,
          "variation_id":varient_id,
          "quantity":quantity,
          "productid":quantity,


        }

    ) .then((value){
      rslt ="SUCCESS";
      prefs.setString("store", storeid);
      //Navigator.of(context).pop();
    })
        .catchError((error) {
      rslt ="FAILURE";
      print(error);


    });
  }else{
    rslt="RMVCART";
  }


    return rslt ;
}

Future CartValueUpdate(strId,varient_id,qty) async{


  var rslt = "WORKING";
   print("varint");
   print(varient_id);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final User user = firebaseAuth.currentUser;
  final uid = user.uid;
  await  FirebaseFirestore.instance.collection("cart").doc(uid).collection(strId).doc(varient_id).update(
      {
        // "id": uid.toString(),

        "quantity": int.parse(qty.toString()),



      }

  ) .then((value){
    rslt ="SUCCESS";
    //Navigator.of(context).pop();
  })
      .catchError((error) {
    rslt ="FAILURE";


  });

  return rslt ;
}


Future updatedCart(doc,qty) async{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final User user = firebaseAuth.currentUser;
  final uid = user.uid;

  var rslt = "WORKING";
  await  FirebaseFirestore.instance.collection("cart").doc(uid).collection(uid).doc(doc).update(
      {
        // "id": uid.toString(),

        "quantity": qty.toString(),



      }

  ) .then((value){
    rslt ="SUCCESS";
    //Navigator.of(context).pop();
  })
      .catchError((error) {
    rslt ="FAILURE";


  });


  return rslt ;
}

Future DeleteCart(doc,vid) async{


  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final User user = firebaseAuth.currentUser;
  final uid = user.uid;

  var rslt = "WORKINGDlt";
  await  FirebaseFirestore.instance.collection("cart").doc(uid).collection(vid).doc(doc).delete().then((value){
    rslt ="SUCCESSDlt";
    //Navigator.of(context).pop();
  })
      .catchError((error) {
    rslt ="FAILUREDlt";


  });

  return rslt ;
}

Future deleteAllCart() async{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final User user = firebaseAuth.currentUser;
  final uid = user.uid;

  var rslt = "0";

  var prefs = await SharedPreferences.getInstance();
//  var device_id = prefs.getString('token');

  // var strLong = prefs.getString('long');
  // var strLat = prefs.getString('lat');
  var currentStore = prefs.getString('store');

  FirebaseFirestore.instance.collection("cart").doc(uid).collection(currentStore)
      .get()
      .then((QuerySnapshot querySnapshot) => {
    querySnapshot.docs.forEach((doc) {
      // print("doc");
      doc.reference.delete();

    })
  }).whenComplete(()async{

    rslt = "SUCCESS";
    var prefs = await SharedPreferences.getInstance();

    prefs.setString("store", null);
    // for (var i = 0; i < arrList['variation'].length; i++) {
    //   print(arrList[i]['products']['variation']);
    // }


  });


  return rslt ;
}


Future addFav() async{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final User user = firebaseAuth.currentUser;
  final uid = user.uid;

  var rslt = "WORKING";
  await  FirebaseFirestore.instance.collection('favorites').doc(uid).collection(uid).add(
      {
       //  "id": uid.toString(),
       // "lat":strLat,



      }

  ) .then((value){
    rslt ="SUCCESS";

    //Navigator.of(context).pop();
  })
      .catchError((error) {
    rslt ="FAILURE";
    print(error);


  });


  return rslt ;
}





Future rmvFav(varient_id) async{


  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final User user = firebaseAuth.currentUser;
  final uid = user.uid;

  var rslt = "WORKING";
  await  FirebaseFirestore.instance.collection("cart").doc(uid).collection(uid).doc(varient_id).delete().then((value){
    rslt ="SUCCESS";
    //Navigator.of(context).pop();
  })
      .catchError((error) {
    rslt ="FAILURE";


  });

  return rslt ;
}


Future addAdd(lat,long,adress,landmark,unit,full) async{
  // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // final User user = firebaseAuth.currentUser;
  // final uid = user.uid;

  String device_id = await DeviceId.getID;
  print(device_id);

  var rslt = "WORKING";
  await  FirebaseFirestore.instance.collection('address').doc(device_id).collection(device_id).add(
      {
        "lat": lat.toString(),
        "long":long.toString(),
        "adress":adress.toString(),
        "landmark":landmark.toString(),
        "unit":unit.toString(),
        "full":full.toString(),



      }

  ) .then((value){
    rslt ="SUCCESS";

    //Navigator.of(context).pop();
  })
      .catchError((error) {
    rslt ="FAILURE";
    print(error);


  });


  return rslt ;
}

Future updatedAdd(doc) async{
  // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // final User user = firebaseAuth.currentUser;
  // final uid = user.uid;


  String device_id = await DeviceId.getID;
  print(device_id);
  var rslt = "WORKING";
  await  FirebaseFirestore.instance.collection("address").doc(device_id).collection(device_id).doc(doc).update(
      {
        // "id": uid.toString(),

       // "quantity": int.parse(qty.toString()),



      }

  ) .then((value){
    rslt ="SUCCESS";
    //Navigator.of(context).pop();
  })
      .catchError((error) {
    rslt ="FAILURE";


  });


  return rslt ;
}

Future dltAdd(varient_id) async{

  String device_id = await DeviceId.getID;
  print(device_id);
  // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // final User user = firebaseAuth.currentUser;
  // final uid = user.uid;

  var rslt = "WORKING";
  await  FirebaseFirestore.instance.collection("address").doc(device_id).collection(device_id).doc(varient_id).delete().then((value){
    rslt ="SUCCESS";
    //Navigator.of(context).pop();
  })
      .catchError((error) {
    rslt ="FAILURE";


  });

  return rslt ;
}


