import 'package:zomatoui/helper/networkutils.dart';
import 'package:zomatoui/helper/page_transation_fade_animation.dart';
import 'package:zomatoui/resources.dart';
import 'package:zomatoui/screens/restaurant_menu_ui.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VegItems extends StatefulWidget {

  var data;

  // static const routeName = "/property-sell";

  VegItems({Key key, this.data}) : super(key: key);
  @override
  _VegItemsState createState() => _VegItemsState();
}

class _VegItemsState extends State<VegItems> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0,left: 10,right: 10),
      child: InkWell(
        onTap: (){
          Navigator.push(context, FadeRoute(page: RestaurantMenu( id:widget.data['id']
          )));
        },
        child: Container(
          height: 120,
          width: width,
          child: Row(
            children: [
              Stack(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                              image: NetworkImage(
                                  ImgBaseUrl+widget.data['logo'].toString()),
                              fit: BoxFit.cover),
                        )),
                  ),
                  Positioned(
                      bottom: 12,
                      left: 4,
                      child: Card(
                        elevation: 2,
                        margin: EdgeInsets.all(0),
                        color: Colors.indigoAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(3),topRight: Radius.circular(3)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:6.0,vertical: 4),
                          child: Center(
                            child: Shimmer.fromColors(
                              baseColor: Colors.indigo[100],
                              period: Duration(milliseconds: 800),
                              highlightColor: Colors.white,
                              child: Text(widget.data['offer_percentage'].toString()+" % OFF",style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  letterSpacing: 0.6,
                                  wordSpacing: 1,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600
                              )),
                            ),
                          ),
                        ),
                      )
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.data['store_name'].toString(), style: boldTitleTxt),
                      SizedBox(height: 6,),
                      Text(
                        widget.data['store_sub_type'].toString(),
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      SizedBox(height: 2,),
                      Text(
                        "₹" +widget.data['rate_for_two'].toString()+ "for two"+ "•"+ widget.data['approximate_delivery_time'].toString()+" mins",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      SizedBox(height: 4,),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.yellow[800],
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "4.2 / 5",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
