
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/Api/profileApi.dart';
import 'package:zomatoui/helper/page_transation_fade_animation.dart';
import 'package:zomatoui/res/comida_icons_icons.dart';
import 'package:zomatoui/resources.dart';
import 'package:zomatoui/screens/login_ui.dart';
import 'package:zomatoui/screens/manage_address.dart';
import 'package:zomatoui/screens/offers_ui.dart';
import 'package:zomatoui/screens/payment_ui.dart';
import 'package:zomatoui/screens/update_profile.dart';
import 'package:flutter/material.dart';

class AccountFragment extends StatefulWidget {
  final title;

  AccountFragment({this.title});

  @override
  _AccountFragmentState createState() => _AccountFragmentState();
}

class _AccountFragmentState extends State<AccountFragment> {
  ScrollController _scrollController;
  bool lastStatus = true;
  var arrList =[];
 var name ="";
 var addrss ="";
  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (100 - kToolbarHeight);
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  @override
  void initState() {
    this.getStoresk();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }




  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }




  Future<String> getStoresk() async {
    print("resjjjjjjpoonse");
    var rsp = await profile();
    print("data");
    print(rsp);
    setState(() {
       name =rsp['first_name'];
       addrss =rsp['email'];
      // print("data");
      // print(data);
    });


    print("respoonse");
   // print(rsp['']);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
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
        elevation: isShrink ? 1 : 0,
        toolbarHeight: isShrink ? 56 : 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: appbar,
                          ),
                          Text(
                            addrss,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      child: SizedBox(
                        width: 80,
                        height: 30,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                FadeRoute(page: UpdateProfile()));
                          },
                          child: Text(
                            "EDIT",
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: ListTile(
              leading: Icon(Icons.pin_drop,size: 20),
              minLeadingWidth: 20,
              tileColor: Colors.white,
              onTap: (){
                Navigator.push(context,
                    FadeRoute(page: ManageAddress(title: manageAddress,)));
              },
              title: Text(
                manageAddress,
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Icon(Icons.keyboard_arrow_right,size: 16,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:0.8),
            child: ListTile(
              leading: Icon(ComidaIcons.offer,size: 20),
              minLeadingWidth: 20,
              tileColor: Colors.white,
              onTap: (){
                Navigator.push(
                  context,
                  FadeRoute(
                    page: OffersUI(
                      title: "Offers",
                      isApplyCoupon: false,
                    ),
                  ),
                );
              },
              title: Text(
                offers,
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Icon(Icons.keyboard_arrow_right,size: 16,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:0.8),
            child: ListTile(
              leading: Icon(Icons.credit_card_outlined,size: 20),
              minLeadingWidth: 20,
              tileColor: Colors.white,
              onTap: (){
                Navigator.push(
                  context,
                  FadeRoute(
                    page: PaymentUI(
                      title: confirmNdPay,
                    ),
                  ),
                );
              },
              title: Text(
                payModes,
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Icon(Icons.keyboard_arrow_right,size: 16,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:0.8),
            child: ListTile(
              leading: Icon(Icons.help_outline_rounded,size: 20),
              minLeadingWidth: 20,
              tileColor: Colors.white,
              onTap: (){

              },
              title: Text(
                Help,
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Icon(Icons.keyboard_arrow_right,size: 16,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:8),
            child: ListTile(
              tileColor: Colors.white,
              onTap: ()async{
                SharedPreferences prefs =
                await SharedPreferences.getInstance();
                prefs.setString("token", null);
               _signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) =>  LoginUI()));
              },
              title: Text(
                logout,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    letterSpacing: 0.6,
                    color: Colors.red,
                    fontWeight: FontWeight.w600
                ),
              ),
              trailing: Icon(Icons.power_settings_new_sharp,size: 20,color: Colors.red,),
            ),
          ),
        ],
      ),
    );
  }
}
