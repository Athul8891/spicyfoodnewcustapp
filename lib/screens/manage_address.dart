
import 'package:zomatoui/helper/page_transation_fade_animation.dart';
import 'package:zomatoui/resources.dart';
import 'package:flutter/material.dart';

import 'add_address_ui.dart';

class ManageAddress extends StatefulWidget {
  final title;

  ManageAddress({this.title});

  @override
  _ManageAddressState createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: appbar,
        ),
        elevation: 1,
        actions: [
          IconButton(icon: Icon(Icons.add_location_alt,size: 18,), onPressed: (){
            Navigator.push(
              context,
              FadeRoute(
                page: AddAddressUI(),
              ),
            );
          }),
          SizedBox(width: 8,),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            color: Colors.blueGrey[50].withOpacity(0.98),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    saveAddress.toUpperCase(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 2,
            padding: EdgeInsets.only(top:12.0),
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.home_outlined,
                      size: 22,
                    ),
                    SizedBox(width: 16,),
                    Expanded(
                      flex:1,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Home",
                              style: titleBold,
                            ),
                            Text(
                              address,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 30,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        FadeRoute(
                                          page: AddAddressUI(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "EDIT",
                                      style: TextStyle(color: Colors.deepOrange),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 30,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "DELETE",
                                      style: TextStyle(color: Colors.deepOrange),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(height: 6,),
                            Divider()
                          ]
                      ),),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
