import 'package:flutter/material.dart';

class FunkyOverlay extends StatefulWidget {
  final widget;
  final title;


  FunkyOverlay({this.widget, this.title});

  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.ease);

    controller.addListener(() {
      setState(() {
      });
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              height: 350,
              decoration: ShapeDecoration(
                  color: Colors.grey[50].withOpacity(0.99),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: widget.widget
              ),
            ),
          ),
        ),
      ),
    );
  }
}