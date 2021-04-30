import 'package:zomatoui/Api/orderListApi.dart';
import 'package:zomatoui/helper/page_transation_fade_animation.dart';
import 'package:zomatoui/resources.dart';
import 'package:zomatoui/screens/rate_ui.dart';
import 'package:flutter/material.dart';

import 'cart_ui.dart';
import 'order_detail.dart';

class OrderHistory extends StatefulWidget {
  final title;


  OrderHistory({this.title});

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {

  var arrList =[];

  @override
  void initState() {
    this.getStores();
  }





  Future<String> getStores() async {

    var rsp = await orderList();
    setState(() {
      arrList=rsp;

    });
    print("respoonse");
    print(rsp);
  }
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
          automaticallyImplyLeading: false,
        ),
        body: ListView.builder(
          //itemCount: 2,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: arrList != null ? arrList.length : 0,
          itemBuilder: (context, index) {
            final item = arrList != null ? arrList[index] : null;
            print("statussssssssss");
            print(item['store']);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    FadeRoute(
                      page: OrderDetailUI(
                        title: "Order #451245",
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                item['store_name'].toString(),
                                style: appbar,
                              ),
                            ),
                            Text(
                              item['customer_status'].toString(),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(width: 5,),
                            Icon(
                              Icons.check_circle,
                              size: 15,
                              color: Colors.green,
                            )
                          ],
                        ),
                        Text(
                          item['location'].toString(),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "₹"+item['total'].toString(),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Divider(),
                        Text(
                          item['items'][0].toString()+" x "+item['items'][0].toString() ,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Text(
                          deliveryDate,
                          style: subtitleTxt,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextButton(
                                style: outLineBtn,
                                onPressed: () {
                                  Navigator.push(context, FadeRoute(page: CartUI()));
                                },
                                child: Text(
                                  "reorder".toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      letterSpacing: 1,
                                      color: Colors.green[600],
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextButton(
                                style: rateOrderBtn,
                                onPressed: () {
                                  Navigator.push(context, FadeRoute(page: RateUI(title: rateDelivery,)));
                                },
                                child: Text(
                                  "rate order".toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      letterSpacing: 1,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
