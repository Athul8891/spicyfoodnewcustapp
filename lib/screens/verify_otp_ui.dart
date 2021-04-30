import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/Api/LoginApi.dart';
import 'package:zomatoui/helper/common.dart';
import 'package:zomatoui/helper/snackbar_toast_helper.dart';
import 'package:zomatoui/resources.dart';
import 'package:zomatoui/screens/add_profile.dart';
import 'package:zomatoui/screens/fregment_container.dart';
import 'package:flutter/material.dart';

class VerifyOTPUI extends StatefulWidget {
  final title;
  final otp;
  final  num;

  VerifyOTPUI({this.title,this.otp,this.num});

  @override
  _VerifyOTPUIState createState() => _VerifyOTPUIState();
}

class _VerifyOTPUIState extends State<VerifyOTPUI> with SingleTickerProviderStateMixin {

  GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
  AnimationController controller;
  Animation<double> animation;

  TextEditingController _edtController1 = new TextEditingController();
  TextEditingController _edtController2 = new TextEditingController();
  TextEditingController _edtController3 = new TextEditingController();
  TextEditingController _edtController4 = new TextEditingController();
  TextEditingController _edtController5 = new TextEditingController();
  TextEditingController _edtController6 = new TextEditingController();

  bool isTaped=false;

  bool isButtonEnabled=false;




  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String _verificationId;

  var isPressed= false ;

  User _firebaseUser;
  String _status;

  AuthCredential _phoneAuthCredential;
  int _code;
  bool isEmpty(){
    setState(() {
      if((_edtController1.text.length==1) &&
          (_edtController2.text.length==1) &&
          (_edtController3.text.length==1) &&
          (_edtController4.text.length==1)&&
          (_edtController5.text.length==1)&&
          (_edtController6.text.length==1)

      )
      {
        isButtonEnabled=true;
      }
      else{
        isButtonEnabled=false;
      }
    });
    return isButtonEnabled;
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 4000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }
  Future<void> _login() async {
    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this._phoneAuthCredential)
          .then((UserCredential authRes)async {


        _firebaseUser = authRes.user;
        print("llllllllllllllll");
        // print(_firebaseUser);
        final User user = auth.currentUser;
        final uid = user.uid;
        print(uid);
        // await prefs.setString('id', uid.toString());

        if (_firebaseUser != null) {
          // Check is already sign up
          // Navigator.push(
          //     context,
          //     new MaterialPageRoute(
          //         builder: (context) =>   BottomNav()));
          setState(() {
            isPressed =false ;
          });

          gotoHome();


            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (context) => AddProfile()));



          //
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => BottomNav()));

        } else {
          Fluttertoast.showToast(msg: "Sign in fail");
          this.setState(() {
            // isLoading = false;
          });
        }

      }).catchError((e) => print(e));
      setState(() {

        //_status += 'Signed In\n';
      });
    } catch (e) {
      setState(() {
        isPressed =false ;
      });

      print(e);
    }
  }
  void _submitOTP() {
    /// get the `smsCode` from the user
    ///
    String smsCode = _otpController.text.toString().trim();

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    this._phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: this.widget.otp.toString(), smsCode: smsCode);

    _login();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[100],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: width,
              height: 120,
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title.toUpperCase(),style: Theme.of(context).textTheme.headline5,),
                    Text(
                      "OTP sent to +91 ${Common.phoneNumber}",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter OTP".toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left:0.0,right: 16),
                          child: TextField(
                              controller: _edtController1,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline5,
                              onSubmitted: null,
                              onChanged: (val) {
                                setState(() {
                                  FocusScope.of(context).nextFocus();
                                  isEmpty();
                                });
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                counterText: "",
                              )),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                              controller: _edtController2,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline5,
                              onSubmitted: null,
                              onChanged: (val) {
                                setState(() {
                                  FocusScope.of(context).nextFocus();
                                  isEmpty();
                                });
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                counterText: "",
                              )),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8),
                          child: TextField(
                              controller: _edtController3,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline5,
                              onSubmitted: null,
                              onChanged: (val) {
                                setState(() {
                                  FocusScope.of(context).nextFocus();
                                  isEmpty();
                                });
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                counterText: "",
                              )),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left:16.0,right: 0),
                          child: TextField(
                              controller: _edtController4,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline5,
                              onSubmitted: null,
                              onChanged: (val) {
                                setState(() {
                                  FocusScope.of(context).nextFocus();
                                  isEmpty();
                                });
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                counterText: "",
                              )),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8),
                          child: TextField(
                              controller: _edtController5,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline5,
                              onSubmitted: null,
                              onChanged: (val) {
                                setState(() {
                                  FocusScope.of(context).nextFocus();
                                  isEmpty();
                                });
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                counterText: "",
                              )),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left:16.0,right: 0),
                          child: TextField(
                              controller: _edtController6,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline5,
                              onSubmitted: null,
                              onChanged: (val) {
                                setState(() {
                                  FocusScope.of(context).nextFocus();
                                  isEmpty();
                                });
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                counterText: "",
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Text(
                  //       "01:56 ".toUpperCase(),
                  //       style: Theme.of(context).textTheme.subtitle2,
                  //     ),
                  //     InkWell(
                  //         onTap: () {
                  //         },
                  //         child: Text(
                  //           "resend".toUpperCase(),
                  //           style: txtButton,
                  //         ))
                  //   ],
                  // ),
                  SizedBox(height: 50,),
                  isTaped?Stack(
                    alignment: Alignment.center,
                    children: [
                      LinearProgressIndicator(
                        minHeight: 45,
                        value: animation.value,
                        backgroundColor: Colors.red[100],
                        semanticsLabel: "Loading...",
                        semanticsValue: "Loading...",
                      ),
                      Text(
                        "Wait a movement",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ],
                  ): SizedBox(
                      width: width,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: isButtonEnabled?(){
                          setState(() {
                            _otpController.text=_edtController1.text+
                                _edtController2.text+
                                _edtController3.text+
                                _edtController4.text+
                                _edtController5.text+
                                _edtController6.text;


                            _submitOTP();
                            // print(s);
                            // print(Common.otp);
                            //
                            // if(s==Common.otp){
                            //   gotoHome();
                            //   print("true");
                            // }
                            // print("false");
                          });
                        }:null,
                        child: Text(
                          isButtonEnabled?"continue".toUpperCase():"Enter OTP",
                          style: Theme.of(context).textTheme.button,
                        ),
                        style:ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) return isButtonEnabled ? accentColor : Colors.red[100];
                              return isButtonEnabled ? accentColor : Colors.red[100];
                              // Use the component's default.
                            },
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void gotoHome() async {
    isTaped=true;
    Timer(
        Duration(seconds: 5),
            () {

          // Navigator.pushReplacement(
          //       context, MaterialPageRoute(builder: (context) => AddProfile()));
        });

    var rsp = await  loginApi(widget.num);
     if(rsp['response_code'].toString()=="SPC_002"){
       SharedPreferences prefs =
       await SharedPreferences.getInstance();
       prefs.setString("token", rsp['token'].toString());
       Navigator.pushReplacement(
           context, MaterialPageRoute(builder: (context) => FragmentContainer()));
     }
     else if(rsp['response_code'].toString()=="SPC_001"){
       Navigator.pushReplacement(
           context, MaterialPageRoute(builder: (context) => AddProfile()));
     }
     else{
       showToastError("Something went wrong !");
     }
  }
}
