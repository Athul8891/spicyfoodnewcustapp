import 'package:zomatoui/account_fragment.dart';
import 'package:zomatoui/home_fragment.dart';
import 'package:zomatoui/res/comida_icons_icons.dart';
import 'package:zomatoui/resources.dart';
import 'package:zomatoui/screens/order_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../favorite_fragment.dart';
class FragmentContainer extends StatefulWidget {
  @override
  _FragmentContainerState createState() => _FragmentContainerState();
}

class _FragmentContainerState extends State<FragmentContainer> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  List<Widget> _children = [
    new HomeFragment(),
    new FavouriteFragment(title: "Favorite",),
    new OrderHistory(title: "Order History",),
    new AccountFragment(title: "My Account",),
  ];

  bool _isVisible;
  ScrollController _scrollController;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
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
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: AnimatedBuilder(
        animation: _scrollController,
        builder: (context,child){
          return AnimatedContainer(
            duration: Duration(milliseconds: 400),
            height: _isVisible ? 56 : 0,
            child: child,
          );
        },
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          iconSize: 20,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: accentColor,
          unselectedItemColor: Colors.grey,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            new BottomNavigationBarItem(
              icon: Icon(ComidaIcons.home_bag),
              label: "Comida"
            ),
            new BottomNavigationBarItem(
              icon: Icon(
                FlutterIcons.favorite_mdi,
              ),
              label: "Favorite"
            ),
            new BottomNavigationBarItem(
              icon: Icon(ComidaIcons.history),
              label: "History"
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Account"
            ),
          ],
        ),
      ),
    );
  }
}
