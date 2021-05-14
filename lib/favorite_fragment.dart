import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zomatoui/resources.dart';

import 'common.dart';
import 'list_item/flat_item.dart';

class FavouriteFragment extends StatefulWidget {
  final title;
  FavouriteFragment({this.title});

  @override
  _FavouriteFragmentState createState() => _FavouriteFragmentState();
}

class _FavouriteFragmentState extends State<FavouriteFragment> {
  // var pgLoad = true;
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
      body: FutureBuilder(
        builder: (context, snapshot) {
          var restaurantList = json.decode(snapshot.data.toString());
          if (snapshot.hasData) {
            return Container(
              color: Colors.white,
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.builder(
                  itemCount: 0,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    //RestaurantsModel model = restaurantList[index];
                    Common.totalRestaurants = restaurantList.length;
                    return FlatItem(
                      title: restaurantList[index]['title'],
                      thumb: restaurantList[index]['thumb'],
                      cuisines: restaurantList[index]['cuisines'],
                      offer: restaurantList[index]['offer'],
                      rating: restaurantList[index]['rating'],
                      readyDuration: restaurantList[index]['ready_duration'],
                      isOpen: restaurantList[index]['isOpen'],
                      isFav: true,
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
    );
  }
}
