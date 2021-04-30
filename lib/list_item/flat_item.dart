
import 'package:zomatoui/helper/networkutils.dart';
import 'package:zomatoui/helper/page_transation_fade_animation.dart';
import 'package:zomatoui/resources.dart';
import 'package:zomatoui/screens/restaurant_menu_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

class FlatItem extends StatefulWidget {
  final id;
  final title;
  final thumb;
  final cuisines;
  final readyDuration;
  final offer;
  final rating;
  final isOpen;
  final isFav;

  FlatItem(
      {this.id,
      this.title,
      this.thumb,
      this.cuisines,
      this.readyDuration,
      this.offer,
      this.rating,
        this.isOpen,
        this.isFav
      });

  @override
  _FlatItemState createState() => _FlatItemState();
}

class _FlatItemState extends State<FlatItem>
    with SingleTickerProviderStateMixin {

  bool isAdd=false;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: allRadius,
      ),
      elevation: 6,
      margin: EdgeInsets.all(12),
      child: InkWell(
        borderRadius: allRadius,
        splashColor: Colors.blue[50],
        onTap: () {


          Navigator.push(context, FadeRoute(page: RestaurantMenu(id:widget.id.toString()
          )));
        },
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                    width: width, height: 180, decoration: BoxDecoration(
                  borderRadius: topRadius,
                  image: DecorationImage(
                      image: NetworkImage(ImgBaseUrl+widget.thumb.toString()),
                      fit: BoxFit.cover
                  ),
                )),
                Positioned(
                  top: 8,
                  right: 8,
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: FloatingActionButton(
                      heroTag: null,
                        elevation: 1,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        onPressed: () {
                          setState(() {
                            isAdd = !isAdd;
                          });
                        },
                        child: Icon(isAdd?FlutterIcons.favorite_mdi: FlutterIcons.favorite_border_mdi,color: isAdd?Colors.red:Colors.grey[700],size: 15,),),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white54,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:6.0,vertical: 4),
                      child: Center(
                        child: Text(widget.readyDuration,style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[800]
                        ),),
                      ),
                    ),
                  )
                ),
                Positioned(
                    bottom: 8,
                    left: 0,
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.all(0),
                      color: Colors.indigoAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(3),topRight: Radius.circular(3)),
                      ),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:6.0,vertical: 4),
                          child: Center(
                            child: Shimmer.fromColors(
                              baseColor: Colors.indigo[100],
                              period: Duration(milliseconds: 800),
                              highlightColor: Colors.white,
                              child: Text(widget.offer.toString(),style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  letterSpacing: 0.3,
                                  wordSpacing: 1,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600
                              )),
                            ),
                          ),
                        ),
                      ),
                    )
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.title.toString(), style: boldTitleTxt),
                        SizedBox(
                          width: 8,
                        ),
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
                              "${widget.rating} / 5",
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.cuisines,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "₹150 per person • 31 mins",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  // widget.isOpen?SizedBox(height: 0,):Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //   child: Text(
                  //     "Opens at 08:00 AM",
                  //     style: TextStyle(
                  //       color: Colors.red[700],
                  //       fontSize: 12
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  var log = Logger();
  Widget setupAlertDialogContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Gujarat, India'),
            onTap: (){
              setState(() {

                log.d("Tapped on List tile");
              });
            },
          );
        },
      ),
    );
  }
}
