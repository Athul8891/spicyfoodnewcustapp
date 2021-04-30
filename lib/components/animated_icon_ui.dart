
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:zomatoui/components/animated_alert_dialog.dart';

class AnimatedIconUI extends StatefulWidget {
  @override
  _AnimatedIconUIState createState() => _AnimatedIconUIState();
}

class _AnimatedIconUIState extends State<AnimatedIconUI>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool isMenu = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: 110,
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey[800])
              ),
            ),
          ),
          onPressed:() => _handleOnPressed(),
          child: Row(
            children: [
              AnimatedIcon(
                icon: AnimatedIcons.close_menu,
                progress: _animationController,
                size: 20,
                color: Colors.white,

              ),
              SizedBox(width: 6,),
              Text(isMenu?"Menu":"Close",style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  letterSpacing: 0.6,
                  color: Colors.white,
                  fontWeight: FontWeight.w600
              ),)
            ],
          ),
        ),
      ),
    );
  }

  void _handleOnPressed() {
    setState(() {
      isMenu = !isMenu;
      isMenu
          ? _animationController.forward()
          : _animationController.reverse();
      if(!isMenu){
        showDialog(
            context: context,
            builder: (_) => FunkyOverlay(widget: setupAlertDialogContainer(),title: "MENU",),
          );
      }
    });
  }
  var log = Logger();
  Widget setupAlertDialogContainer() {
    return Container(
      height: 300.0,
      width: 300.0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Gujarat, India'),
            onTap: (){
              setState(() {

                log.d("Tapped on List tile");
              });
            },
          );
        },
      ),
    );
  }
}