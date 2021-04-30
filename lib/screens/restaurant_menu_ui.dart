import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zomatoui/Api/FirebaseApi.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

typedef Widget IndexedWidgetBuilder(BuildContext context, int index);

class RestaurantMenu extends StatefulWidget {
  final id;



  RestaurantMenu({this.id,});

  @override
  _RestaurantMenuState createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu> {
  ScrollController _scrollController;
  bool lastStatus = true;

  bool isExpanded = true;

  bool isCartVisible=false;

  bool isCounter = false;
  var cartItems=[];

  int count = 0;
  int _selectedIndex = 0;
  var storeName="";
  var storeType="";
  var storeRating=0;
  var storeTime="";
  var itemTotal="";
  var storeId=0;
  var iSstoreOffer=false;
  var storeOffer=0;
  var arrList = [];
  var arrCouponList = [];
  var cartLength = "";
  var arrProdList = [];
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
    this.getStores();
    this.getAllCartItems();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    aController.removeListener(_scrollListener);
    super.dispose();
  }

  Future<String> getStores() async {
    var rspstore = await storeDetailsApi("3");
    print("resposeeeeeeeeee");
    print(rspstore);
     if(rspstore['store']!=null){
       setState(() {
         storeId = rspstore['store']['id'];
         storeName = rspstore['store']['store_name'];
         storeType = rspstore['store']['store_sub_type'];
         storeRating = rspstore['store']['store_name'];
         storeTime = rspstore['store']['approximate_delivery_time'];
         storeOffer = rspstore['store']['offer_percentage'];
         iSstoreOffer = rspstore['store']['store_offer'];

         arrList= rspstore['category'];
         arrCouponList= rspstore['coupouns'];
         print('arrList');
         print(storeName);
         // if (arrList != null) {
         //   for (var value in arrList) {
         //     if (value['products'] != null) {
         //       final name = value['products'];
         //       print("name");
         //       print(name);
         //       //arrImages.add(NetworkImage(imgConst + name));
         //     }
         //
         //
         //   }
         //
         //
         //
         // }

         for (var i = 0; i < arrList.length; i++) {
            print("valueeeee");
           print(arrList[i]['name']);
            arrProdList.add(arrList[i]['products']);
            arrProdList.insert(0,0);
            var dummy=[{'qty' : 0}];
            print("valueeeee2");
           print(arrProdList);
            print("valueeeee2");


           if(arrProdList.length!=0){

             print(arrList[i]['products'][0]['variation']);
             variationList.add(arrList[i]['products'][0]['variation']);
            // variationList2.add(arrList[i]['products'][0]['variation']);
         //   productList.add([arrList[i]['products'][0]['name'],arrList[i]['products'][0]['description'],arrList[i]['products'][0]['image'],arrList[i]['products'][0]['veg'],arrList[i]['products'][0]['in_stock'],arrList[i]['products'][0]['price']]);
             foodItems.add(FoodItem(arrList[i]['name'], arrList[i]['products'])); }
            print("variationnnn");
            print(variationList);

          // arrProdList.addAll(arrList[i]['products']);

           // print(arrProdList[0]['name']);



           // FoodItem(this.title, this.contents, this.discription,this.price,this.image);

            arrProdList.clear();
         }

         //
         // foodItems.add(FoodItem("title", "contents", icon));
       });
     }


  }


  void  getAllCartItems()async{

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final User user = firebaseAuth.currentUser;
    final uid = user.uid;

    FirebaseFirestore.instance.collection("cart").doc(uid).collection("3")
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        // print("doc");
        setState(() {
          cartLength=querySnapshot.docs.length.toString();
          if(int.parse(cartLength.toString()) >0){
            isCartVisible= true;
          }
          cartItems.add({'variation_id': doc.get('variation_id'),  'quantity': int.parse(doc.get('quantity').toString())});
        });
      })
    }).whenComplete(()async{
      print("cartLi44st");
      print(cartItems);
      var rsp = await cartUpload("3",cartItems);
      print("rsppppppp");
      print(rsp);
      setState(() {

        //arrListCart = rsp['cart']['cartitem'];
        itemTotal = rsp['cart']['final_total'].toString();
         print("totalsss");

         print(itemTotal);
         print(cartLength);
        //   print(arrList['variation']);

      });
      // for (var i = 0; i < arrList['variation'].length; i++) {
      //   print(arrList[i]['products']['variation']);
      // }


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
           var rsp =   deleteAllCart();
           if(rsp=="SUCCESS"){
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

  bool isAdd=false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        body: CustomScrollView(
          controller: aController,
          slivers: [
            SliverAppBar(
              centerTitle: false,
              titleSpacing: 0.0,
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      isAdd?FlutterIcons.favorite_mdi: FlutterIcons.favorite_border_mdi,
                      size: 20,
                      color: isAdd?Colors.red:Colors.grey[700],
                    ),
                    onPressed: () {
                      setState(() {
                        isAdd = !isAdd;
                      });
                    }),
                IconButton(
                    icon: Icon(
                      ComidaIcons.search,
                      size: 18,
                    ),
                    onPressed: () {
                      Navigator.push(context, FadeRoute(page: SearchUI()));
                    }),
                SizedBox(
                  width: 8,
                )
              ],
              floating: false,
              pinned: true,
              elevation: 1,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
              title: AnimatedOpacity(
                  opacity: !isShade ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(storeName!=null?storeName:"", style: boldTitleTxt),
                      // widget.isOpen?Text(widget.readyDuration, style: Theme.of(context).textTheme.subtitle2)
                      //     :Text(
                      //   "Opens at 08:00 AM",
                      //   style: TextStyle(
                      //       color: Colors.red[700],
                      //       fontSize: 12
                      //   ),
                      // ),
                    ],
                  )),
              backgroundColor: Colors.white,
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(storeName!=null?storeName:"", style: appbar),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                       storeType,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 12,
                              unratedColor: Colors.grey[300],
                              itemPadding: EdgeInsets.only(right: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: null),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "${0.0}",
                            style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 0.6,
                                color: Colors.grey,
                                decorationThickness: 3,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.watch_later_outlined,
                                size: 10,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                               storeTime+" mins",
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.directions_outlined,
                                size: 10,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Live Tracking",
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      // widget.isOpen?SizedBox(height: 0,):Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //   child: Text(
                      //     "Opens at 08:00 AM",
                      //     style: TextStyle(
                      //         color: Colors.red[700],
                      //         fontSize: 12
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 0.5),
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: 58,
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    //itemCount: 4,
                    padding: EdgeInsets.only(left: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: arrCouponList != null ? arrCouponList.length : 0,
                    itemBuilder: (context, index) {
                      final item = arrCouponList != null ? arrCouponList[index] : null;
                      return Padding(
                        padding:
                        const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                        child: ClipPath(
                          clipper: MovieTicketClipper(),
                          child: ElevatedButton(
                            style: offerButton,
                            onPressed: () {},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(item['title'].toString(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        letterSpacing: 0.3,
                                        wordSpacing: 0.6,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                                Text("use code " + item['code'].toString().toUpperCase(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 10,
                                        letterSpacing: 1.2,
                                        wordSpacing: 0.5,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 6),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green[100].withOpacity(0.3)),
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
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
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
                    final item  = arrList != null ? arrList[index] : null;
                    return AutoScrollTag(
                     // key: ValueKey(i),
                      controller: aController,
                     // index: i,
                      child: ExpansionTile(
                        collapsedBackgroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        initiallyExpanded: isExpanded,
                        title: new Text(
                          item['name'].toString(),
                          style: appbar,
                        ),
                        children: <Widget>[
                          new Column(
                            children: _buildExpandableContent(foodItems[index],index),
                          ),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: SizedBox(
            width: 110,
            child: ElevatedButton(
              style: menuButton,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => FunkyOverlay(
                    widget: setupAlertDialogContainer(),
                    title: "",
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    FlutterIcons.chef_hat_mco,
                    size: 16,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Menu".toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        letterSpacing: 1,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: AnimatedContainer(
          duration: Duration(milliseconds: 800),
          height: isCartVisible?65:0,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: ElevatedButton(
                  style:addToCartButton,
                  onPressed: () {
                    Navigator.push(context, FadeRoute(page: CartUI()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                       cartLength+ " Items | ₹"+itemTotal.toUpperCase(),
                        style: Theme.of(context).textTheme.button,
                      ),
                      Text(
                        "view cart >".toUpperCase(),
                        style: Theme.of(context).textTheme.button,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
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

  _buildExpandableContent(FoodItem vehicle,int index) {
    List<Widget> columnContent = [];
    int _itemCount = 0;
    for (dynamic content in vehicle.contents)
          // print(content);
          // print("content");


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
                    child: Icon(Icons.brightness_1, size: 9, color: Colors.green),
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
                          "₹"+content['price'].toString(),
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
                                    ImgBaseUrl+content['image'].toString()),
                                fit: BoxFit.cover),
                          )),
                    ),
                    Positioned(
                        bottom: 1,
                        left: 10,
                        child: SizedBox(
                          height: 40,
                          width: 87,
                          child: content['trending']>1
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
                                          if (content['trending'] == 1) {
                                            isCounter = false;
                                            isCartVisible=false;
                                          } else {
                                            content['trending']--;
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
                                  content['trending'].toString(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          content['trending']++;
                                          print("_itemCount");
                                          print(_itemCount);
                                          isCartVisible=true;
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
                                  onPressed: ()async {

                                    var qty = "1";
                                    if(variationList[index].length==1){
                                      setState(() {
                                        content['trending']++;

                                      });
                                      isCounter = true;
                                      isCartVisible=true;
                                      print("vvvvvv1vvv");
                                      var id = 0;
                                      var name = "";
                                      var price = 0;
                                      var product = 0;

                                     // print( variationList[index][0]);
                                      for (var value in variationList[index]) {
                                        id = value['id'];
                                        name = value['name'];
                                        price = value['price'];
                                        product = value['product'];

                                      }
                                      var rsp = await addToCart(id.toString(),content['store'].toString(),qty,product.toString(),storeId.toString());
                                      if(rsp=="SUCCESS"){
                                        showToastSuccess("Item added to cart!");
                                      }
                                      else if(rsp=="RMVCART"){
                                        _onBackPressed(storeId.toString());
                                      }
                                      else{
                                        showToastError("Item adding failed!");
                                      }

                                      print(rsp);
                                    }else{
                                      setState(() {
                                        isCounter = true;
                                        print("vvvvvvvvv");
                                        // print( variationList[index].length);
                                      //  _showBottomSheet(index);
                                        if (content['trending'] > 0) {
                                          isCounter = true;
                                          isCartVisible=true;
                                          _showBottomSheet(index,content['name'].toString(),content['description'].toString(),content['store'].toString());
                                        } else {
                                          content['trending']++;
                                          isCounter = false;
                                          isCartVisible=false;
                                        }
                                      });
                                    }

                                  },
                                  style: addButton,
                                  child: Center(
                                    child: Text("ADD",
                                        style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1.3,
                                            wordSpacing: 1,
                                            color: Colors.green,
                                            fontStyle: FontStyle.normal)),
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
          )
      ));

    return columnContent;
  }

  SingingCharacter _character = SingingCharacter.half;

  void _showBottomSheet(int pos,var name,var disc,var id) {
   var varitem = variationList[pos];

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
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                              style:
                                              Theme.of(context).textTheme.headline6,
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
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),

                                  Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: varitem != null ? varitem.length : 0,
                                      itemBuilder: (context, index) {

                                        final item = varitem != null ? varitem[index] : null;
                                        print("item['name']") ;
                                        print(index) ;
                                        return  RadioListTile(
                                          title:  Text(
                                            item['name'] ,
                                            style: titleTxt,
                                          ),
                                          value: index,
                                          groupValue: _selectedIndex,

                                          onChanged: ( value) {


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
                                        style: Theme.of(context).textTheme.headline6,
                                      ),
                                      SizedBox(
                                        width: 120,
                                        height: 50,
                                        child: Card(
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
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
                                                          isCartVisible=false;
                                                          Navigator.pop(context);
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
                              var rsp = await addToCart(varitem[_selectedIndex]['id'].toString(),id.toString(),count.toString(),varitem[_selectedIndex]['product'].toString(),storeId.toString());
                            //  var rsp = await addToCart(varitem[_selectedIndex]['id'],id.toString(),count,varitem[_selectedIndex]['product']);
                              print(rsp);
                              if(rsp=="SUCCESS"){
                                showToastSuccess("Item added to cart!");
                              }
                              else if(rsp=="RMVCART"){
                                _onBackPressed(storeId.toString());
                              }
                              else{
                                showToastError("Item adding failed!");
                              }
                              setModelState((){
                                isCartVisible=true;
                                Navigator.pop(context);
                                setState(() {
                                  isCartVisible=true;
                                });
                              });
                            },
                            child: Text(
                              "Add ₹150".toUpperCase(),
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
  List<dynamic> contents = [];

  //final IconData icon;

  FoodItem(this.title, this.contents);
}

List<FoodItem> foodItems = [];
