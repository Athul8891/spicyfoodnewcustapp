import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:zomatoui/account_fragment.dart';
import 'package:zomatoui/home_fragment.dart';
import 'package:zomatoui/res/comida_icons_icons.dart';
import 'package:zomatoui/resources.dart';
import 'package:zomatoui/screens/order_history.dart';

import '../favorite_fragment.dart';

class FragmentContainer extends StatefulWidget {
  @override
  _FragmentContainerState createState() => _FragmentContainerState();
}

class _FragmentContainerState extends State<FragmentContainer>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  List<Widget> _children = [
    new HomeFragment(),
    new FavouriteFragment(
      title: "Favorite",
    ),
    new OrderHistory(
      title: "Order History",
    ),
    new AccountFragment(
      title: "My Account",
    ),
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
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
            selectedLabelStyle: TextStyle(
                color: Color(0xff333333),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold),
            unselectedItemColor: Colors.grey,
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: [
              new BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: "Home",
                  activeIcon: Icon(Icons.home)),
              new BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.heart,
                  ),
                  activeIcon: Icon(
                    CupertinoIcons.heart_fill,
                  ),
                  label: "Favourite"),
              new BottomNavigationBarItem(
                  icon: Icon(ComidaIcons.history), label: "History"),
              new BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: "Account"),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    HapticFeedback.mediumImpact();
    if (_currentIndex != 0) {
      print("aaaaaaaaaaaaaa");
      setState(() {
        _currentIndex = 0;
        print(_currentIndex);
      });
    } else {
      print("dgvsgdbvadsbhb");
      _showDialog();
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
        elevation: 10,
        title: Text('Confirm Exit!'),
        titleTextStyle: TextStyle(
            fontSize: 16,
            letterSpacing: 0.6,
            color: Color(0xff333333),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold),
        content: Text('Are you sure you want to exit?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
