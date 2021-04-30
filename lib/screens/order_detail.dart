
import 'package:zomatoui/resources.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class OrderDetailUI extends StatefulWidget {
  final title;

  OrderDetailUI({this.title});

  @override
  _OrderDetailUIState createState() => _OrderDetailUIState();
}

class _OrderDetailUIState extends State<OrderDetailUI> {
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
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _Timeline3(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:1.0),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 15,
                      color: Colors.green,
                    ),
                    SizedBox(width: 16,),
                    Expanded(
                      flex: 1,
                      child: Text(
                        delivered,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    billDetail.toUpperCase(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 2,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 8),
                              child: Row(
                                children: [
                                  veg(),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Maxican Paneer x 5",
                                        style: Theme.of(context).textTheme.headline6,
                                      )),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "₹89",
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Item Total",
                          style: subtitleTxt,
                        ),
                        Text(
                          "₹289.00",
                          style: subtitleTxt,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Deliver charge",
                          style: subtitleTxt,
                        ),
                        Text(
                          "₹18.50",
                          style: subtitleTxt,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Taxes and Charges",
                          style: subtitleTxt,
                        ),
                        Text(
                          "₹2.00",
                          style: subtitleTxt,
                        )
                      ],
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Paid by Paytm",
                            style: titleBold,
                          ),
                          Text(
                            "₹314.50",
                            style: titleBold,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _Timeline3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<_TimelineStatus> data = [
      _TimelineStatus.inProgress,
      _TimelineStatus.inProgress,
    ];

    return Timeline.tileBuilder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      theme: TimelineThemeData(
        nodePosition: 0,
        nodeItemOverlap: true,
        connectorTheme: ConnectorThemeData(
          color: Color(0xffe6e7e9),
          thickness: 1.0,
          indent: 2
        ),
      ),
      padding: EdgeInsets.only(top: 10.0),
      builder: TimelineTileBuilder.connected(
        indicatorBuilder: (context, index) {
          final status = data[index];
          return OutlinedDotIndicator(
            color:
            status.isInProgress ? Color(0xff6ad192) : Color(0xffe6e7e9),
            backgroundColor:
            status.isInProgress ? Color(0xffd4f5d6) : Color(0xffc2c5c9),
            borderWidth: status.isInProgress ? 3.0 : 2.5,
          );
        },
        connectorBuilder: (context, index, connectorType) {
          var color;
          if (index < data.length &&
              data[index].isInProgress &&
              data[index].isInProgress) {
            color = data[index].isInProgress ? Color(0xff6ad192) : null;
          }
          return SolidLineConnector(
            color: color,
          );
        },
        contentsBuilder: (context, index) {
          var height = kTileHeight+10;

          return SizedBox(
            height: height,
            child: Align(
              alignment: Alignment.centerLeft,
              child:Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(restaurantName,style: titleBold,),
                    Text(deliveryDate,style: Theme.of(context).textTheme.subtitle2,),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: data.length,
      ),
    );
  }
}


enum _TimelineStatus {
  inProgress,
}

extension on _TimelineStatus {
  bool get isInProgress => this == _TimelineStatus.inProgress;
}