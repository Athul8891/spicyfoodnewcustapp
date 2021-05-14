import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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
  final total;



  PaymentUI({this.title,this.total});
  @override
  _PaymentUIState createState() => _PaymentUIState();
}

class _PaymentUIState extends State<PaymentUI> {

  Razorpay _razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
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
                var rsp = await  codCheckout("cod");
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
                openCheckout();
               // Navigator.push(context, FadeRoute(page: TrackOrder()));
              },
              title: Text(
                card,
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Icon(Icons.keyboard_arrow_right,size: 16,),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top:0.8),
          //   child: ListTile(
          //     leading:  SvgPicture.asset(
          //         "assets/images/paytm.svg",
          //         width: 30,
          //     ),
          //     tileColor: Colors.white,
          //     onTap: (){
          //
          //     },
          //     title: Text(
          //       paytm,
          //       style: Theme.of(context).textTheme.headline6,
          //     ),
          //     trailing: Icon(Icons.keyboard_arrow_right,size: 16,),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top:0.8),
          //   child: ListTile(
          //     leading:  SvgPicture.asset(
          //         "assets/images/gpay.svg",
          //         width: 30,
          //     ),
          //     tileColor: Colors.white,
          //     onTap: (){
          //
          //     },
          //     title: Text(
          //       gpay,
          //       style: Theme.of(context).textTheme.headline6,
          //     ),
          //     trailing: Icon(Icons.keyboard_arrow_right,size: 16,),
          //   ),
          // ),
        ],
      ),
    );
  }



  void openCheckout() async {
    var options = {
      'key': 'rzp_test_3IXQThw7ZMCHmQ',
      'amount': int.parse(widget.total) * 100,
      'name': 'Spicy Food',
      //'description': 'Fine T-Shirt',
      'image':
      'https://play-lh.googleusercontent.com/JJN6h9vrFZTQTysBKu8NkJEf9yF1HLfcZ_mf7ehkEPuxmbBG08ju8u1VJIOLoCDEc38=s180-rw',
      'prefill': {'contact': "+9188888888", 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async{
    var rsp = await  codCheckout("online");

      Fluttertoast.showToast(
          msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
      Navigator.push(context, FadeRoute(page: ThankYouUI(title: "Order Successful!",)));
      var rsp2 =   deleteAllCart();

    print(rsp);

    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }
}
