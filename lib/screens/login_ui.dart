import 'package:firebase_auth/firebase_auth.dart';
import 'package:zomatoui/helper/common.dart';
import 'package:zomatoui/helper/page_transation_fade_animation.dart';
import 'package:zomatoui/helper/snackbar_toast_helper.dart';
import 'package:zomatoui/resources.dart';
import 'package:zomatoui/screens/verify_otp_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:random_string/random_string.dart';

class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _edtMobileController = new TextEditingController();
  ScrollController _scrollController;
  bool isButtonEnabled = false;
  var _isVisible;



  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String _verificationId;


  User _firebaseUser;
  String _status;
  var isPressed= false ;
  AuthCredential _phoneAuthCredential;
  int _code;


  bool isEmpty() {
    setState(() {
      if (_edtMobileController.text.length == 10) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
    return isButtonEnabled;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _scrollController = new ScrollController();
    });
    _isVisible = true;
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible)
          setState(() {
            _isVisible = false;
          });
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isVisible)
          setState(() {
            _isVisible = true;
          });
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.idle) {
        if (!_isVisible)
          setState(() {
            _isVisible = true;
          });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }


  Future<void> _submitPhoneNumber() async {
    // pr.show();
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
    String phoneNumber = "+91 " + _edtMobileController.text.toString().trim();
    print(phoneNumber);
    // pr.show();
    /// The below functions are the callbacks, separated so as to make code more redable
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      setState(() {
        _status += 'verificationCompleted\n';
      });
      this._phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
    }



    void codeSent(String verificationId, [int code]) {
      print('codeSent');
      this._verificationId = verificationId;
      print(verificationId);
      this._code = code;
      print(code);
      print(code.toString());

      print("_verificationId");
      print(_verificationId);
      setState(() {
        isPressed =false ;
      });


      Navigator.push(
          context,
          FadeRoute(
              page: VerifyOTPUI(
                  title: "Verify details", otp: _verificationId,num: _edtMobileController.text.toString(),)));


      // Navigator.push(
      //     context,
      //     new MaterialPageRoute(
      //         builder: (context) =>   OtpScreen(id: _verificationId,num: _phoneNumberController.text.toString(),)));



    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      setState(() {
        _status += 'codeAutoRetrievalTimeout\n';
      });
      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      timeout: Duration(milliseconds: 10000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      /// When this function is called there is no need to enter the OTP, you can click on Login button to sigin directly as the device is now verified
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: (exception) {
        setState(() {
          isPressed =false ;
        });
        print("failed");
        print(exception);




      },

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        height: height,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "login".toUpperCase(),
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                enterMobileNo,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: _edtMobileController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                cursorHeight: 20,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline6,
                onSubmitted: null,
                onChanged: (val) {
                  setState(() {
                    isEmpty();
                  });
                },
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Mobile number",
                  counterText: "",
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                  width: width,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            if (_edtMobileController.text != null) {
                              Common.phoneNumber = _edtMobileController.text;
                              var otp = randomNumeric(4);
                              print("OTP : " + otp);
                              Common.otp = otp;
                              Common.phoneNumber = _edtMobileController.text;
                          //    showToastSuccess("Your OTP is $otp");
                              _submitPhoneNumber();
                              // Navigator.push(
                              //     context,
                              //     FadeRoute(
                              //         page: VerifyOTPUI(
                              //             title: "Verify details", otp: otp)));
                            } else {
                              customSnackBar(
                                  context,
                                  "Please use 10 times '9's",
                                  "Try again",
                                  _scaffoldKey,
                                  2);
                            }
                          }
                        : null,
                    child: Text(
                      isButtonEnabled
                          ? "continue".toUpperCase()
                          : "Enter mobile number",
                      style: Theme.of(context).textTheme.button,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) return isButtonEnabled ? accentColor : Colors.red[100];
                          return isButtonEnabled ? accentColor : Colors.red[100]; // Use the component's default.
                        },
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
