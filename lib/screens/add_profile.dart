import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/Api/customerCreation.dart';
import 'package:zomatoui/screens/fregment_container.dart';

import '../resources.dart';

class AddProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<AddProfile> {

  TextEditingController _edtMobileController = new TextEditingController();
  TextEditingController _edtFirstController = new TextEditingController();
  TextEditingController _edtEmailController = new TextEditingController();
  bool isButtonEnabled=false;
  var tap = false;
  bool isEmpty() {
    setState(() {
      if (_edtMobileController.text.length == 10 &&
          EmailValidator.validate(_edtEmailController.text)&&_edtFirstController.text != null) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
    return isButtonEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Account",
                style: Theme.of(context).textTheme.headline5,
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
                  labelText: phoneNo,
                  counterText: "",
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: _edtFirstController,
               // keyboardType: TextInputType.emailAddress,
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
                  labelText: "First Name",
                  counterText: "",
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: _edtEmailController,
                keyboardType: TextInputType.emailAddress,
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
                  labelText: emailAddr,
                  counterText: "",
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: isButtonEnabled
                        ? ()async {
                      setState(() {
                        tap=true;
                      });
                      if (_edtMobileController.text != null) {
                           var rsp = await customerCreation(_edtMobileController.text,_edtFirstController.text,_edtEmailController.text,);
                            print("hhhhhh");
                            print(rsp);
                            if(rsp['token']!=null){

                              setState(() {
                                tap=false;
                              });
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              prefs.setString("token", rsp['token'].toString());
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => FragmentContainer()));

                            }
                            else{
                              setState(() {
                                tap=false;
                              });
                            }
                      } else {

                      }
                    }
                        : null,
                    child:tap==true?Text(
                     "ADDING...",
                      style: Theme.of(context).textTheme.button,
                    ): Text(
                      isButtonEnabled
                          ? "Update".toUpperCase()
                          : "Enter mobile number & Email",
                      style: Theme.of(context).textTheme.button,
                    ),
                    style:ButtonStyle(
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
