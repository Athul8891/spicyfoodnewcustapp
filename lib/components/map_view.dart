import 'package:flutter/material.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Show Map View",style: Theme.of(context).textTheme.subtitle2,));
  }
}
