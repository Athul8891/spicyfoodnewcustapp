
import 'package:zomatoui/helper/page_transation_fade_animation.dart';
import 'package:zomatoui/screens/thank_you_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';

import '../resources.dart';


class RateUI extends StatefulWidget {
  final title;

  RateUI({this.title});

  @override
  _RateUIState createState() => _RateUIState();
}

class _RateUIState extends State<RateUI> {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height-200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Lottie.asset("assets/anim/"+reviewAnim,repeat: true,width: MediaQuery.of(context).size.width,height: 300),
                      SizedBox(height: 40,),
                      Text(rateDelivery+" by",style: Theme.of(context).textTheme.subtitle2,),
                      SizedBox(height: 4,),
                    //  Text("Vikas",style: appbar,),
                      SizedBox(height: 16,),
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 25,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8,),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextField(
                    keyboardType: TextInputType.text,
                    cursorHeight: 20,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headline6,
                    onSubmitted: null,
                    onChanged: (val) {
                      setState(() {
                      });
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: likeMost,
                      counterText: "",
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: ElevatedButton(
                        onPressed:(){
                          Navigator.push(context, FadeRoute(page: ThankYouUI(title: "God bless you liked",)));
                        },
                        child: Text(submitFb.toUpperCase(),
                          style: Theme.of(context).textTheme.button,
                        ),
                        style: eleButton,
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
