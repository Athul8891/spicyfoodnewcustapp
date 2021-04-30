import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomatoui/Api/pureVeg.dart';
import 'package:zomatoui/Api/storesNear.dart';
import 'package:zomatoui/Api/trendingList.dart';
import 'package:zomatoui/list_item/category_item.dart';
import 'package:zomatoui/list_item/flat_item.dart';
import 'package:zomatoui/list_item/veg_items.dart';
import 'package:zomatoui/res/comida_icons_icons.dart';
import 'package:zomatoui/resources.dart';
import 'package:zomatoui/screens/offers_ui.dart';
import 'package:zomatoui/screens/popular_cuisines_ui.dart';
import 'package:zomatoui/screens/search_ui.dart';

import 'helper/page_transation_fade_animation.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment>
    with SingleTickerProviderStateMixin {
  bool isVisible = true;
  var _isVisible;
  ScrollController _scrollController;

  AnimationController _animationController;
  bool isPlaying = false;
  var strNowLoc = "";
  var strLong = "";
  var strLat = "";
  bool isCounter = false;
  int count = 0;
  var arrStoreList = [];
  var arrTrendingList = [];
  var arrVegList = [];
  List<Widget> children = [
    Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: allRadius,
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: allRadius,
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/food_one.jpg",
                ),
                fit: BoxFit.cover,
              )),
        )),
    Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: allRadius,
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: allRadius,
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/food_two.jpg",
                ),
                fit: BoxFit.cover,
              )),
        )),
    Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: allRadius,
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: allRadius,
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/food_one.jpg",
                ),
                fit: BoxFit.cover,
              )),
        )),
    Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: allRadius,
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: allRadius,
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/food_two.jpg",
                ),
                fit: BoxFit.cover,
              )),
        )),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  final CarouselController controller = CarouselController();

  @override
  void initState() {
    super.initState();
    this.getStores();
    this._getLocation();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
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

  _getLocation() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      strNowLoc = prefs.getString('currentLoc');
      strLong = prefs.getString('long');
      strLat = prefs.getString('lat');
      // id = prefs.getString('lat');
    });

    print("strId");
    print(strLong);
  }

  Future<String> getStores() async {
    var rspstore = await storeNearApi();
    var rspveg = await pureVegApi();
    var rsptrend = await trendingList();
    setState(() {
      arrStoreList = rspstore['data'];
      arrVegList = rspveg['data'];
      arrTrendingList = rsptrend;
    });

    print("storessssssssss");
    print(rspstore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.pin_drop_outlined,
                        size: 20,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "Home".toUpperCase(),
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.6,
                            color: Color(0xff333333),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    strNowLoc,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              snap: true,
              floating: true,
              elevation: 1,
              toolbarHeight: 48,
              automaticallyImplyLeading: false,
              pinned: true,
              actions: [
                IconButton(
                    icon: Icon(ComidaIcons.offer, color: Colors.grey[600]),
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                          context,
                          FadeRoute(
                            page: OffersUI(
                              title: "Offers",
                              isApplyCoupon: false,
                            ),
                          ),
                        );
                      });
                    })
              ],
              bottom: PreferredSize(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.push(context, FadeRoute(page: SearchUI()));
                        });
                      },
                      child: Container(
                        height: 40.8,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 2)
                            ]),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              ComidaIcons.search,
                              size: 18,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              search,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  preferredSize: Size.fromHeight(60.0)),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CarouselSlider(
                          items: children,
                          carouselController: controller,
                          options: CarouselOptions(
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.95,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 12),
                          child: Text(category, style: boldTitleTxt),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
                child: FutureBuilder(
              builder: (context, snapshot) {
                var showJsonData = json.decode(snapshot.data.toString());

                if (snapshot.hasData) {
                  return Container(
                    height: 115.0,
                    color: Colors.white,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      //itemCount: showJsonData.length,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(left: 12),
                      itemCount:
                          arrTrendingList != null ? arrTrendingList.length : 0,
                      itemBuilder: (context, index) {
                        final item = arrTrendingList != null
                            ? arrTrendingList[index]
                            : null;
                        print("itemmmmmmmmmmmmmmmmmmmmm");
                        print(item);
                        return Category(
                          id: item['id'],
                          title: item['name'],
                          thumb: item['image'],
                        );
                      },
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
              future: DefaultAssetBundle.of(context)
                  .loadString("assets/jsonfiles/category.json"),
            )),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.green[50]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    ComidaIcons.veg,
                                    size: 12,
                                    color: Colors.green[300],
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text("Pure veg".toUpperCase(),
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          letterSpacing: 0.6,
                                          color: Color(0xff333333),
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    FadeRoute(page: PopularCuisines()));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "SEE ALL",
                                    style: boldTitleTxt,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 18,
                                    color: accentColor,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                width: width,
                color: Colors.white,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    //  itemCount: 2,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: arrVegList != null ? arrVegList.length : 0,
                    itemBuilder: (context, index) {
                      final item =
                          arrVegList != null ? arrVegList[index] : null;
                      return VegItems(data: item);
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "${arrStoreList.length} restaurants around you",
                    style: boldTitleTxt,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder(
                builder: (context, snapshot) {
                  //  var restaurantList = json.decode(snapshot.data.toString());
                  if (snapshot.hasData) {
                    return Container(
                      color: Colors.white,
                      child: MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.builder(
                          // itemCount: arrStoreList.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount:
                              arrStoreList != null ? arrStoreList.length : 0,
                          itemBuilder: (context, index) {
                            final item = arrStoreList != null
                                ? arrStoreList[index]
                                : null;
                            //RestaurantsModel model = restaurantList[index];

                            // Common.totalRestaurants = arrStoreList.length;

                            print("daaaaaaaata");
                            print(item['store_sub_type']);
                            return FlatItem(
                              id: item['id'],
                              title: item['store_name'],
                              thumb: item['logo'],
                              cuisines: item['store_sub_type'],
                              offer: item['offer_percentage'],
                              rating: item['rating'],
                              readyDuration: item['approximate_delivery_time'],
                              isOpen: item['logo'],
                              isFav: false,
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
                future: DefaultAssetBundle.of(context)
                    .loadString("assets/jsonfiles/restaurant.json"),
              ),
            ),
          ],
        ));
  }
}
