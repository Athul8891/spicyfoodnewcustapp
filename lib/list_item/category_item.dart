import 'package:zomatoui/helper/networkutils.dart';
import 'package:zomatoui/helper/page_transation_fade_animation.dart';
import 'package:zomatoui/screens/popular_cuisines_ui.dart';
import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  final id;
  final title;
  final thumb;

  Category({this.title, this.thumb,this.id});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, FadeRoute(page: PopularCuisines(id: widget.id,title: widget.title,)));
      },
      child: Padding(
        padding: EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              elevation: 2,
              shadowColor: Colors.orangeAccent,
              child: CircleAvatar(
                backgroundImage: NetworkImage(ImgBaseUrl+widget.thumb),
                maxRadius: 32,
                backgroundColor: Colors.orange,
              ),
            ),
            SizedBox(height: 6,),
            Text(widget.title,style: Theme.of(context).textTheme.headline6,)
          ],
        ),
      ),
    );
  }
}
