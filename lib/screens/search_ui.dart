import 'dart:convert';

import 'package:zomatoui/list_item/category_item.dart';
import 'package:zomatoui/res/comida_icons_icons.dart';
import 'package:zomatoui/resources.dart';
import 'package:flutter/material.dart';

class SearchUI extends StatefulWidget {
  @override
  _SearchUIState createState() => _SearchUIState();
}

class _SearchUIState extends State<SearchUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  decoration: InputDecoration(
                      icon: Icon(ComidaIcons.search,size: 18,),
                      hintText: search,
                      border: InputBorder.none,
                      hintStyle: Theme.of(context).textTheme.subtitle2),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(60.8)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12.0, vertical: 12),
            child: Text(category, style: boldTitleTxt),
          ),
          FutureBuilder(
            builder: (context, snapshot) {
              var showJsonData = json.decode(snapshot.data.toString());

              if (snapshot.hasData) {
                return Container(
                  height: 115.0,
                  color: Colors.white,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: showJsonData.length,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: 12),
                    itemBuilder: (context, index) {
                      return Category(
                        title: showJsonData[index]['title'],
                        thumb: showJsonData[index]['thumb'],
                      );
                    },
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            },
            future: DefaultAssetBundle.of(context)
                .loadString("assets/jsonfiles/category.json"),
          )
        ],
      ),
    );
  }
}
