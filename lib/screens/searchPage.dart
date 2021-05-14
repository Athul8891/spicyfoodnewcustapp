import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:zomatoui/Api/FirebaseApi.dart';
import 'package:zomatoui/Api/SearchApi.dart';
import 'package:zomatoui/Api/StoreDetailsApi.dart';
import 'package:zomatoui/Api/uploadCart.dart';
import 'package:zomatoui/components/animated_alert_dialog.dart';
import 'package:zomatoui/helper/networkutils.dart';
import 'package:zomatoui/helper/page_transation_fade_animation.dart';
import 'package:zomatoui/helper/snackbar_toast_helper.dart';
import 'package:zomatoui/list_item/restaurant_items.dart';
import 'package:zomatoui/res/comida_icons_icons.dart';
import 'package:zomatoui/resources.dart';
import 'package:zomatoui/screens/cart_ui.dart';
import 'package:zomatoui/screens/search_ui.dart';

typedef Widget IndexedWidgetBuilder(BuildContext context, int index);

class SearchPage extends StatefulWidget {
  final id;

  SearchPage({
    this.id,
  });

  @override
  _RestaurantMenuState createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<SearchPage> {
  final searchController = TextEditingController();

  var PgLoad = false;
  ScrollController _scrollController;
  bool lastStatus = true;
  var loading = false;
  bool isExpanded = true;

  bool isCartVisible = false;

  bool isCounter = false;
  var cartItems = [];

  int count = 0;
  int _selectedIndex = 0;
  var storeName = "";
  var storeType = "";
  var storeRating = "";
  var storeTime = "";
  var itemTotal = "";
  var storeId = 0;
  var iSstoreOffer = false;
  var storeOffer = 0;
  var arrList = [];
  var arrCouponList = [];
  var cartLength = "";
  var arrProdList = [];
  List qty = [];
  List<dynamic> arrOrders =List();
  List<dynamic> variationList = [];
  List<String> variationList2 = [];

  AutoScrollController aController;

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (100 - kToolbarHeight);
  }

  bool get isShade {
    return aController.hasClients &&
        aController.offset > (100 - kToolbarHeight);
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  _scrollListenerL() {
    if (isShade != lastStatus) {
      setState(() {
        lastStatus = isShade;
      });
    }
  }

  final scrollDirection = Axis.vertical;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();

    aController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    aController.addListener(_scrollListenerL);

    //this.getAllCartItems();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    aController.removeListener(_scrollListener);
    super.dispose();
  }

  Future<String> getStores(data) async {
    arrList.clear();
    setState(() {
      loading = true;
    });
    var rspstore = await searchApi(data);
    print("resposeeeeeeeeee");
    print(rspstore);



    setState(() {
      arrList=rspstore;

   //   variationList=rspstore['variation'];

      for (var i = 0; i < arrList.length; i++) {
        print("valueeeee");
      //  print(arrList[i]['name']);
        variationList.add(arrList[i]['variation']);
         print(variationList);

      }
    });


    setState(() {
      loading = false;
    });
  }



  Future<bool> _onBackPressed(storeId) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Replace cart item?'),
        content: new Text(
            'If Your cart contains other dishes. It will discard the selection of added dishes!'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () async {
              var rsp = deleteAllCart();
              if (rsp == "SUCCESS") {
                showToastSuccess("Cart cleared!");
              }
            },
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }

  bool isAdd = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],

        appBar: AppBar(
          title: Text(
            "Search",
            style: appbar,
          ),
          elevation: 1,
          bottom: PreferredSize(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 47.8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 2)
                      ]),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: searchController,
                     onChanged: (searchController) async{
                       var search = searchController.toString();

                       getStores(search);

                       },
                    decoration: InputDecoration(
                        icon: Icon(ComidaIcons.search,size: 18,),
                        hintText: "Search",
                        border: InputBorder.none,
                        hintStyle: Theme.of(context).textTheme.subtitle2
                    ),

                  ),
                ),
              ),
              preferredSize: Size.fromHeight(60.8)),
        ),
        body:

        loading == true
            ? Center(child: CircularProgressIndicator())
            :


        CustomScrollView(
          controller: aController,
          slivers: [


            SliverToBoxAdapter(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  scrollDirection: scrollDirection,
                  //  itemCount: foodItems.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: arrList != null ? arrList.length : 0,
                  itemBuilder: (context, index) {
                    print("variationList.length");
                    print(arrList.length);
                    final item = arrList != null ? arrList[index] : null;
                    return   Container(
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
                                              ImgBaseUrl+item['image'].toString()),
                                          fit: BoxFit.cover),
                                    )),
                              ),

                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['name'].toString(), style: boldTitleTxt),
                                  SizedBox(height: 6,),
                                  Text(
                                    item['description'].toString(),
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  SizedBox(height: 2,),
                                  Text(
                                    "₹" +item['price'].toString(),
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
                    );
                  },
                ),
              ),
            ),
          ],
          shrinkWrap: true,
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.only(bottom: 40.0),
        //   child: SizedBox(
        //     width: 110,
        //     child: ElevatedButton(
        //       style: menuButton,
        //       onPressed: () {
        //         showDialog(
        //           context: context,
        //           builder: (_) => FunkyOverlay(
        //             widget: setupAlertDialogContainer(),
        //             title: "",
        //           ),
        //         );
        //       },
        //       child: Row(
        //         children: [
        //           Icon(
        //             FlutterIcons.chef_hat_mco,
        //             size: 16,
        //             color: Colors.white,
        //           ),
        //           SizedBox(
        //             width: 8,
        //           ),
        //           Text(
        //             "Menu".toUpperCase(),
        //             style: TextStyle(
        //                 fontFamily: 'Poppins',
        //                 fontSize: 16,
        //                 letterSpacing: 1,
        //                 color: Colors.white,
        //                 fontWeight: FontWeight.w600),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        // bottomNavigationBar: AnimatedContainer(
        //   duration: Duration(milliseconds: 800),
        //   height: isCartVisible ? 65 : 0,
        //   child: Container(
        //     color: Colors.white,
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: SizedBox(
        //         width: MediaQuery.of(context).size.width,
        //         height: 45,
        //         child: ElevatedButton(
        //           style: addToCartButton,
        //           onPressed: () {
        //             Navigator.push(context, FadeRoute(page: CartUI(id: widget.id,)));
        //           },
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               Text(
        //                 cartLength + " Items | ₹" + itemTotal.toUpperCase(),
        //                 style: Theme.of(context).textTheme.button,
        //               ),
        //               Text(
        //                 "view cart >".toUpperCase(),
        //                 style: Theme.of(context).textTheme.button,
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // )

    );
  }

  var log = Logger();

  Widget setupAlertDialogContainer() {
    return Container(
      height: 300.0,
      width: 300.0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: foodItems.length,
        itemBuilder: (BuildContext context, int index) {
          print("foodItems.length");
          print(foodItems.length);
          return SizedBox(
            height: 40,
            child: ListTile(
                title: Text(
                  foodItems[index].title +
                      " (${foodItems[index].contents.length})",
                  style: Theme.of(context).textTheme.headline6,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await aController.scrollToIndex(index,
                      preferPosition: AutoScrollPosition.begin);
                }),
          );
        },
      ),
    );
  }

  _buildExpandableContent(FoodItem vehicle, int index) {
    List<Widget> columnContent = [];
    int _itemCount = 0;
    print(qty);


    for(var i = 0; i < vehicle.contents.length; i++){
      var content = vehicle.contents[i];

      columnContent.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: new Container(
            height: 120,
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(width: 1, color: Colors.green)),
                    alignment: Alignment.center,
                    child:
                    Icon(Icons.brightness_1, size: 9, color: Colors.green),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(content['name'].toString(), style: boldTitleTxt),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          content['description'].toString(),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "₹" + content['price'].toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                  flex: 1,
                ),
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
                                    ImgBaseUrl + content['image'].toString()),
                                fit: BoxFit.cover),
                          )),
                    ),
                    Positioned(
                        bottom: 1,
                        left: 10,
                        child: SizedBox(
                          height: 40,
                          width: 87,
                          child: content['quantity'] > 1
                              ? Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          if (content['quantity'] == 1) {
                                            isCounter = false;
                                            isCartVisible = false;
                                          } else {
                                            content['quantity']--;
                                          }
                                        });
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.green,
                                        size: 15,
                                      )),
                                ),
                                Text(
                                  content['quantity'].toString(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {

                                        setState(() {
                                          content['quantity']++;
                                          print("_itemCount");
                                          print(_itemCount);
                                          isCartVisible = true;
                                        });
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.green,
                                        size: 15,
                                      )),
                                ),
                              ],
                            ),
                          )
                              : Stack(
                            children: [
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    var qty = "1";
                                    print("qtyyyyy");
                                    print(variationList[index].length);
                                    if (variationList[index].length ==
                                        1) {
                                      setState(() {
                                        content['quantity']++;
                                      });
                                      isCounter = true;
                                      isCartVisible = true;
                                      print("vvvvvv1vvv");
                                      var id = 0;
                                      var name = "";
                                      var price = 0;
                                      var product = 0;

                                      // print( variationList[index][0]);
                                      for (var value
                                      in variationList[index]) {
                                        id = value['id'];
                                        name = value['name'];
                                        price = value['price'];
                                        product = value['product'];
                                      }
                                      var rsp = await addToCart(
                                          id.toString(),
                                          content['store'].toString(),
                                          qty,
                                          product.toString(),
                                          storeId.toString());
                                      if (rsp == "SUCCESS") {
                                        showToastSuccess(
                                            "Item added to cart!");
                                      } else if (rsp == "RMVCART") {
                                        _onBackPressed(
                                            storeId.toString());
                                      } else {
                                        showToastError(
                                            "Item adding failed!");
                                      }

                                      print(rsp);
                                    } else {
                                      setState(() {
                                        isCounter = true;
                                        print("vvvvvvvvv");
                                        content['quantity']++;
                                        // print( variationList[index].length);
                                        //  _showBottomSheet(index);
                                        if (content['quantity'] > 0) {

                                          isCounter = true;
                                          isCartVisible = true;
                                          _showBottomSheet(
                                              index,
                                              content['name'].toString(),
                                              content['description']
                                                  .toString(),
                                              content['store']
                                                  .toString(),content['quantity'].toString(),i);
                                        } else {
                                          // content['quantity']++;
                                          isCounter = false;
                                          isCartVisible = false;
                                        }
                                      });
                                    }

                                    print("qtyyyendyy");
                                  },
                                  style: addButton,
                                  child: Center(
                                    child: FittedBox(
                                      child: Text("ADD",
                                          style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 1.3,
                                              wordSpacing: 1,
                                              color: Colors.green,
                                              fontStyle:
                                              FontStyle.normal)),
                                    ),
                                  ),
                                ),
                              ),

                              // Positioned(
                              //   bottom: 5,
                              //   left: 25,
                              //   child: Text(
                              //     "customize",
                              //     style: TextStyle(
                              //         fontSize: 8, color: Colors.grey),
                              //   ),
                              // )
                            ],
                          ),
                        )),
                  ],
                ),
              ],
            ),
          )));
      print(content);
    }

    // print(content);
    // print("content");




    return columnContent;
  }

  SingingCharacter _character = SingingCharacter.half;

  void _showBottomSheet(int pos, var name, var disc, var id,var qty,i) {
    var varitem = variationList[pos];
    print("pos");
    print(pos);
    showMaterialModalBottomSheet(
        context: context,
        elevation: 4,
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setModelState) {
                return Container(
                  height: 520,
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/food_two.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        veg(),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: appbar,
                                            ),
                                            Text(
                                              disc,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Text(
                                    "Quantity",
                                    style: titleBold,
                                  ),
                                  Text(
                                    "Please select any one option",
                                    style:
                                    Theme.of(context).textTheme.subtitle2,
                                  ),

                                  Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount:
                                      varitem != null ? varitem.length : 0,
                                      itemBuilder: (context, index) {
                                        final item = varitem != null
                                            ? varitem[index]
                                            : null;
                                        print("item['name']");
                                        print(index);
                                        return RadioListTile(
                                          title: Text(
                                            item['name'],
                                            style: titleTxt,
                                          ),
                                          value: index,
                                          groupValue: _selectedIndex,
                                          onChanged: (value) {
                                            setModelState(() {
                                              print(value);
                                              _selectedIndex = value;
                                              // Navigator.pop(context);
                                              // _showBottomSheet( pos,name,disc);
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  // RadioListTile<SingingCharacter>(
                                  //   title: const Text(
                                  //     'Half ₹0',
                                  //     style: titleTxt,
                                  //   ),
                                  //   value: SingingCharacter.half,
                                  //   groupValue: _character,
                                  //   onChanged: (SingingCharacter value) {
                                  //     setModelState(() {
                                  //       _character = value;
                                  //     });
                                  //   },
                                  // ),
                                  // RadioListTile<SingingCharacter>(
                                  //   title: const Text(
                                  //     'Full ₹70',
                                  //     style: titleTxt,
                                  //   ),
                                  //   value: SingingCharacter.full,
                                  //   groupValue: _character,
                                  //   onChanged: (SingingCharacter value) {
                                  //     setModelState(() {
                                  //       _character = value;
                                  //     });
                                  //   },
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      SizedBox(
                                        width: 120,
                                        height: 50,
                                        child: Card(
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(4),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: TextButton(
                                                    onPressed: () {
                                                      setModelState(() {
                                                        if (count <= 1) {
                                                          isCounter = false;
                                                          isCartVisible = false;
                                                          Navigator.pop(
                                                              context);
                                                        } else {
                                                          count--;
                                                        }
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.remove,
                                                      color: Colors.green,
                                                      size: 15,
                                                    )),
                                              ),
                                              Text(
                                                count.toString(),
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: TextButton(
                                                    onPressed: () {
                                                      setModelState(() {
                                                        count++;
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.green,
                                                      size: 15,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          child: ElevatedButton(
                            style: addToCartButton,
                            onPressed: () async {
                              print("dddddddddddddddd");
                              print(id.toString());
                              var rsp = await addToCart(
                                  varitem[_selectedIndex]['id'].toString(),
                                  id.toString(),
                                  count.toString(),
                                  varitem[_selectedIndex]['product'].toString(),
                                  storeId.toString());
                              //  var rsp = await addToCart(varitem[_selectedIndex]['id'],id.toString(),count,varitem[_selectedIndex]['product']);
                              print(rsp);
                              if (rsp == "SUCCESS") {
                                setState(() {
                                  foodItems[pos].contents[i]['quantity']=count;

                                  count= 0;
                                });
                                showToastSuccess("Item added to cart!");
                              } else if (rsp == "RMVCART") {
                                _onBackPressed(storeId.toString());
                              } else {
                                showToastError("Item adding failed!");
                              }
                              setModelState(() {
                                isCartVisible = true;
                                Navigator.pop(context);
                                setState(() {
                                  isCartVisible = true;
                                });
                              });


                            },
                            child: Text(
                              "Add".toUpperCase(),
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ));
  }
}

class FoodItem {
  final String title;
  List contents = [];

  //final IconData icon;

  FoodItem(this.title, this.contents);
}

List<FoodItem> foodItems = [];
