import 'package:shimmer/shimmer.dart';
import 'package:zomatoui/Api/trendingListing.dart';
import 'package:zomatoui/helper/networkutils.dart';
import 'package:zomatoui/helper/page_transation_fade_animation.dart';
import 'package:zomatoui/list_item/veg_items.dart';
import 'package:zomatoui/resources.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:zomatoui/screens/restaurant_menu_ui.dart';

enum RestSort { relevance, costForTwo, deliveryTime, ratng }

class PopularCuisines extends StatefulWidget {

  final title;
  final id;

  PopularCuisines({this.title, this.id});
  @override
  _PopularCuisinesState createState() => _PopularCuisinesState();
}

class _PopularCuisinesState extends State<PopularCuisines> {
var arrList =[];

  @override
  void initState() {
       this.getStores();
  }





  Future<String> getStores() async {
    print("widget.id");
    print(widget.id);
    var rsp = await trendingListingApi(widget.id);
    setState(() {
      arrList=rsp;

    });
    print("respoonse");
    print(rsp);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              widget.title.toString(),
              style: appbar,
            ),
            floating: false,
            pinned: true,
            elevation: 1,
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16),
                    child: Text(
                      arrList.length.toString()+" "+nearByRest,
                      style: boldTitleTxt,
                    ),
                  ),
                  Container(
                    width: width,
                    color: Colors.white,
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        //itemCount: 10,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: arrList != null ? arrList.length : 0,
                        itemBuilder: (context, index) {
                          final item = arrList != null ? arrList[index] : null;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0,left: 10,right: 10),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, FadeRoute(page: RestaurantMenu( id:widget.id
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
                                                        ImgBaseUrl+item['logo'].toString()),
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
                                                    child: Text("45 % OFF",style: TextStyle(
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
                                            Text(item['store_name'].toString(), style: boldTitleTxt),
                                            SizedBox(height: 6,),
                                            Text(
                                              item['store_sub_type'].toString(),
                                              style: Theme.of(context).textTheme.subtitle2,
                                            ),
                                            SizedBox(height: 2,),
                                            Text(
                                              "₹"+item['rate_for_two'].toString()+ " per person"+ " • "+ item['approximate_delivery_time'].toString()+"mins",
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
                                                  item['rating'].toString()+" / 5",
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
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   color: Colors.grey[50],
      //   child: Row(
      //     children: [
      //       Expanded(
      //         flex: 1,
      //         child: TextButton(
      //             onPressed: () {
      //               showSort();
      //             },
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 Icon(
      //                   Icons.sort_outlined,
      //                   size: 16,
      //                 ),
      //                 SizedBox(
      //                   width: 12,
      //                 ),
      //                 Text(
      //                   "sort".toUpperCase(),
      //                   style: TextStyle(
      //                       fontFamily: 'Poppins',
      //                       fontSize: 13,
      //                       letterSpacing: 1,
      //                       color: Colors.grey[800],
      //                       fontWeight: FontWeight.w400),
      //                 ),
      //               ],
      //             )),
      //       ),
      //       Container(
      //         height: 25,
      //         color: Colors.grey[300],
      //         width: 1,
      //       ),
      //       Expanded(
      //         flex: 1,
      //         child: TextButton(
      //             onPressed: () {
      //               showFilter();
      //             },
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 Icon(
      //                   Icons.filter_alt_sharp,
      //                   size: 16,
      //                 ),
      //                 SizedBox(
      //                   width: 12,
      //                 ),
      //                 Text(
      //                   "filter".toUpperCase(),
      //                   style: TextStyle(
      //                       fontFamily: 'Poppins',
      //                       fontSize: 13,
      //                       letterSpacing: 1,
      //                       color: Colors.grey[800],
      //                       fontWeight: FontWeight.w400),
      //                 ),
      //               ],
      //             )),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  RestSort _character = RestSort.relevance;
  bool isCheck = true;

  void showSort() {
    showMaterialModalBottomSheet(
        isDismissible: false,
        bounce: true,
        enableDrag: false,
        context: context,
        builder: (context) => SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModelState) {
                return Container(
                  height: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 25,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            "Sort",
                            style: appbar,
                          )
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16),
                        child: Text(
                          showResBy.toUpperCase(),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                      RadioListTile<RestSort>(
                        title: const Text(
                          rel,
                          style: titleTxt,
                        ),
                        value: RestSort.relevance,
                        groupValue: _character,
                        onChanged: (RestSort value) {
                          setModelState(() {
                            _character = value;
                          });
                        },
                      ),
                      RadioListTile<RestSort>(
                        title: const Text(
                          costForTwo,
                          style: titleTxt,
                        ),
                        value: RestSort.costForTwo,
                        groupValue: _character,
                        onChanged: (RestSort value) {
                          setModelState(() {
                            _character = value;
                          });
                        },
                      ),
                      RadioListTile<RestSort>(
                        title: const Text(
                          deliveryTime,
                          style: titleTxt,
                        ),
                        value: RestSort.deliveryTime,
                        groupValue: _character,
                        onChanged: (RestSort value) {
                          setModelState(() {
                            _character = value;
                          });
                        },
                      ),
                      RadioListTile<RestSort>(
                        title: const Text(
                          rating,
                          style: titleTxt,
                        ),
                        value: RestSort.ratng,
                        groupValue: _character,
                        onChanged: (RestSort value) {
                          setModelState(() {
                            _character = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            child: TextButton(
                              onPressed: () {},
                              style: accentButton,
                              child: Text(
                                "Apply",
                                style: Theme.of(context).textTheme.button,
                              ),
                            )),
                      ),
                    ],
                  ),
                );
              }),
            ));
  }

  void showFilter() {
    showMaterialModalBottomSheet(
        isDismissible: false,
        bounce: true,
        enableDrag: false,
        context: context,
        builder: (context) => SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModelState) {
                return Container(
                  height: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 25,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            "Filter",
                            style: appbar,
                          )
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16),
                        child: Text(
                          "Cuisines".toUpperCase(),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:16.0),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 15,
                              itemBuilder: (context, index) {
                                return CheckboxListTile(
                                  title: const Text('Burger',style: titleTxt,),
                                  value: isCheck,
                                  onChanged: (bool value) {
                                    setModelState(
                                      () {
                                        isCheck = !isCheck;
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            child: TextButton(
                              onPressed: () {},
                              style: accentButton,
                              child: Text(
                                "Apply",
                                style: Theme.of(context).textTheme.button,
                              ),
                            )),
                      ),
                    ],
                  ),
                );
              }),
            ));
  }


}
