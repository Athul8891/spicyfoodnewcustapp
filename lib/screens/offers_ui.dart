import 'package:flutter/material.dart';
import 'package:zomatoui/resources.dart';

class OffersUI extends StatefulWidget {
  final title;
  final isApplyCoupon;

  OffersUI({this.title, this.isApplyCoupon});

  @override
  _OffersUIState createState() => _OffersUIState();
}

class _OffersUIState extends State<OffersUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50].withOpacity(0.99),
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text(widget.title.toUpperCase()),
        elevation: 1,
      ),
      body: ListView(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: widget.isApplyCoupon,
                    child: Container(
                      height: 47.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0.0),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 2)
                          ]),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: enterCoupon,
                                  border: InputBorder.none,
                                  hintStyle:
                                      Theme.of(context).textTheme.subtitle2),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Apply".toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    avlCoupon.toUpperCase(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
            itemCount: 5,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.orange),
                                  color: Colors.orange[50].withOpacity(0.99)),
                              width: 100,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: SelectableText(
                                    "comida50".toUpperCase(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        letterSpacing: 1,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.isApplyCoupon,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Apply".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange[700],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          getDiscount,
                          style: titleBold,
                        ),
                        Divider(),
                        Text(
                          discountMsg,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
