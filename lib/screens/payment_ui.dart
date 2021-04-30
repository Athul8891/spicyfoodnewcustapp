import 'package:zomatoui/Api/FirebaseApi.dart';
import 'package:zomatoui/Api/codCheckout.dart';
import 'package:zomatoui/helper/page_transation_fade_animation.dart';
import 'package:zomatoui/screens/thank_you_ui.dart';
import 'package:zomatoui/screens/track_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources.dart';

class PaymentUI extends StatefulWidget {
  final title;


  PaymentUI({this.title});
  @override
  _PaymentUIState createState() => _PaymentUIState();
}

class _PaymentUIState extends State<PaymentUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50].withOpacity(0.99),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: appbar,
        ),
        elevation: 1,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "select payment mEthod".toUpperCase(),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: ListTile(
              leading: SvgPicture.asset(
                "assets/images/cod.svg",
                width: 30,
              ),
              tileColor: Colors.white,
              onTap: ()async{
                var rsp = await  codCheckout();
                if(rsp['status_code']=="SPC_025"){
                  Navigator.push(context, FadeRoute(page: ThankYouUI(title: "Order Successful!",)));
                  var rsp =   deleteAllCart();
                }
                print(rsp);
               // Navigator.push(context, FadeRoute(page: TrackOrder()));
              },
              title: Text(
                "COD",
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Icon(Icons.keyboard_arrow_right,size: 16,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:0.8),
            child: ListTile(
              leading: SvgPicture.asset(
                  "assets/images/card.svg",
                  width: 30,
              ),
              tileColor: Colors.white,
              onTap: (){
                Navigator.push(context, FadeRoute(page: TrackOrder()));
              },
              title: Text(
                card,
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Icon(Icons.keyboard_arrow_right,size: 16,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:0.8),
            child: ListTile(
              leading:  SvgPicture.asset(
                  "assets/images/paytm.svg",
                  width: 30,
              ),
              tileColor: Colors.white,
              onTap: (){

              },
              title: Text(
                paytm,
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Icon(Icons.keyboard_arrow_right,size: 16,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:0.8),
            child: ListTile(
              leading:  SvgPicture.asset(
                  "assets/images/gpay.svg",
                  width: 30,
              ),
              tileColor: Colors.white,
              onTap: (){

              },
              title: Text(
                gpay,
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Icon(Icons.keyboard_arrow_right,size: 16,),
            ),
          ),
        ],
      ),
    );
  }
}
