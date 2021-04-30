import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../resources.dart';

class ThankYouUI extends StatefulWidget {
  final title;

  ThankYouUI({this.title});

  @override
  _ThankYouUIState createState() => _ThankYouUIState();
}

class _ThankYouUIState extends State<ThankYouUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 60,child: IconButton(icon: Icon(Icons.close,size: 25,), onPressed: (){
              Navigator.of(context).pop();
            })),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Thank you",style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      letterSpacing: 0.6,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700
                  ),),
                  SizedBox(height: 16,),
                  Lottie.asset(
                    "assets/anim/smile.json",
                    repeat: true,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                  ),
                  SizedBox(height: 40,),
                  Text("Yeh !",style: appbar,),
                  Text(widget.title,style: Theme.of(context).textTheme.headline6,),
                  SizedBox(height: 40,),
                  TextButton(
                    style:outLineBtn,
                    onPressed: () {
                    },
                    child: Text(
                      "continue".toUpperCase(),
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          letterSpacing: 1,
                          color: Colors.green[600],
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
