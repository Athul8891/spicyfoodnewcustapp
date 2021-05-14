import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/Api/FirebaseApi.dart';
import 'package:zomatoui/Api/uploadCart.dart';
import 'package:zomatoui/helper/page_transation_fade_animation.dart';
import 'package:zomatoui/res/comida_icons_icons.dart';
import 'package:zomatoui/screens/payment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../resources.dart';
import 'offers_ui.dart';

class CartUI extends StatefulWidget {

  final id;

  CartUI({
    this.id,
  });
  @override
  _CartUIState createState() => _CartUIState();
}

class _CartUIState extends State<CartUI> {

  var strNowLoc = "";
  var strLong = "";
  var strLat = "";

  var itemTotal = "";
  var delvryCharge = "";
  var tax = "";
  var toPay = "";
var loading=true;
  var cartItems=[];
  var arrList = [];
  @override
  void initState() {
this._getLocation();
this.getAllCartItems();
  }

  _getLocation() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      strNowLoc = prefs.getString('currentLoc');
      strLong = prefs.getString('long');
      strLat = prefs.getString('lat');
      // id = prefs.getString('lat');
    });

    print("strId");
    print(strLong);}
  void  getAllCartItems()async{
       arrList.clear();
       cartItems.clear();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final User user = firebaseAuth.currentUser;
    final uid = user.uid;

    FirebaseFirestore.instance.collection("cart").doc(uid).collection(widget.id)
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        // print("doc");
        setState(() {
          cartItems.add({'id': doc.documentID.toString(), 'variation_id': doc.get('variation_id'),  'quantity': int.parse(doc.get('quantity').toString())});
        });
      })
    }).whenComplete(()async{
      print("cartLi44st");
      print(cartItems);
      var rsp = await cartUpload(widget.id,cartItems);
      print(rsp);
      setState(() {
        arrList = rsp['cart']['cartitem'];
        print("ivdenok");
        loading = false;
        print(rsp);
        print("ivdenok");
        itemTotal = rsp['cart']['cart_total'].toString();
        delvryCharge = rsp['cart']['delivery_charge'].toString();
        tax = rsp['cart']['cgst'].toString();
        toPay = rsp['cart']['final_total'].toString();


        print("listttt");
     //   print(arrList['variation']);

      });
      // for (var i = 0; i < arrList['variation'].length; i++) {
      //   print(arrList[i]['products']['variation']);
      // }


    });







  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50].withOpacity(0.99),
      appBar: AppBar(
        toolbarHeight: 60,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        //    Text("Aroma"),
            Text(
              strNowLoc,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
        elevation: 1,
      ),
      body:loading==true? Center(child: CircularProgressIndicator())
          :  ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          Container(
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
            //  itemCount: 4,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: arrList != null ? arrList.length : 0,
              itemBuilder: (context, index) {
                final item  = arrList != null ? arrList[index] : null;
                print("item['variation']");

                var variation = item['variation'];

                print(variation);
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Row(
                      children: [
                        veg(),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            flex: 1,
                            child: Text(
                              variation['name'].toString(),
                              style: titleBold,
                            )),
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide(
                                color: Colors.blueGrey[100],
                                width: 1
                              )
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          loading=true;
                                        });
                                        if(cartItems[index]['quantity'] <= 1){
                                          var rsp = await DeleteCart(cartItems[index]['id'].toString(),widget.id.toString());
                                          print("rsp");
                                          print(rsp);

                                          getAllCartItems();
                                        }else{
                                          setState(() {
                                            cartItems[index]['quantity']-- ;
                                          });
                                          var qty =cartItems[index]['quantity'] ;
                                          qty-- ;
                                          var rsp =await CartValueUpdate(widget.id.toString(),cartItems[index]['id'].toString(),qty);
                                          print("rsp");
                                          print(rsp);

                                          //var id = item['_id'].toString();
                                          getAllCartItems();
                                        }

                                        //
                                        // arrList[index]['quantity']-- ;
                                        // if(arrList[index]['quantity']<=1)
                                        // setState(() {
                                        //   arrList[index]['quantity']-- ;
                                        // });
//
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.green,
                                        size: 15,
                                      )),
                                ),
                                Text(
                                  cartItems[index]['quantity'].toString(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () async{

                                        setState(() {
                                          cartItems[index]['quantity']++ ;
                                        });
                                        setState(() {
                                          loading=true;
                                        });
                                        var qty =cartItems[index]['quantity'] ;
                                        qty++ ;
                                        var rsp = await CartValueUpdate(widget.id.toString(),cartItems[index]['variation_id'].toString(),qty);
                                        print("rsp");
                                        print(rsp);

                                        getAllCartItems();


                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.green,
                                        size: 15,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "₹"+variation['price'].toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Container(
                  height: 50,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                        icon: Icon(
                          FlutterIcons.list_alt_faw,
                          size: 18,
                        ),
                        hintText: cusReq,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            letterSpacing: 0.6,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  color: Colors.white,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: OffersUI(
                                title: "apply coupon",
                                isApplyCoupon: true,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              ComidaIcons.offer,
                              size: 16,
                              color: Colors.grey[800],
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "apply coupon".toUpperCase(),
                              style: boldTitleTxt,
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bill Detail",
                              style: titleTxt,
                            ),
                            Text(
                              "",
                              style: titleTxt,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Item Total",
                              style: subtitleTxt,
                            ),
                            Text(
                              "₹"+itemTotal,
                              style: subtitleTxt,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Deliver charge",
                              style: subtitleTxt,
                            ),
                            Text(
                              "₹"+delvryCharge,
                              style: subtitleTxt,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Taxes and Charges",
                              style: subtitleTxt,
                            ),
                            Text(
                              "₹"+tax,
                              style: subtitleTxt,
                            )
                          ],
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "To Pay",
                                style: titleBold,
                              ),
                              Text(
                                "₹"+toPay,
                                style: titleBold,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[50],
        height: 50,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "total".toUpperCase(),
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          letterSpacing: 1,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    Text(
                      "₹"+toPay.toUpperCase(),
                      style: titleBold
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 25,
              color: Colors.grey[300],
              width: 1,
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: accentButton,
                    onPressed: () {
                      Navigator.push(
                        context,
                        FadeRoute(
                          page: PaymentUI(
                            title: confirmNdPay,total: toPay,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "proceed to pay".toUpperCase(),
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          letterSpacing: 0.6,
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                      )
                    ),),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
