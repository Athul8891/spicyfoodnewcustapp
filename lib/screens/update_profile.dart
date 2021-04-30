import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../resources.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {

  TextEditingController _edtMobileController = new TextEditingController();
  TextEditingController _edtEmailController = new TextEditingController();
  bool isButtonEnabled=false;

  bool isEmpty() {
    setState(() {
      if (_edtMobileController.text.length == 10 &&
          EmailValidator.validate(_edtEmailController.text)) {
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
                editAccount,
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
                        ? () {
                      if (_edtMobileController.text != null) {

                      } else {

                      }
                    }
                        : null,
                    child: Text(
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
