import 'package:flutter/material.dart';

class ExpandList extends StatefulWidget {
  @override
  _ExpandListState createState() => new _ExpandListState();
}

class _ExpandListState extends State<ExpandList> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, i) {
          return new ExpansionTile(
            collapsedBackgroundColor: Colors.white,
            backgroundColor: Colors.white,
            title: new Text(vehicles[i].title, style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
            children: <Widget>[
              new Column(
                children: _buildExpandableContent(vehicles[i]),
              ),
            ],
          );
        },
      ),
    );
  }

  _buildExpandableContent(Vehicle vehicle) {
    List<Widget> columnContent = [];

    for (String content in vehicle.contents)
      columnContent.add(
        new ListTile(
          title: new Text(content, style: new TextStyle(fontSize: 18.0),),
          leading: new Icon(vehicle.icon),
        ),
      );

    return columnContent;
  }
}

class Vehicle {
  final String title;
  List<String> contents = [];
  final IconData icon;

  Vehicle(this.title, this.contents, this.icon);
}

List<Vehicle> vehicles = [
  new Vehicle(
    'Bike',
    ['Vehicle no. 1', 'Vehicle no. 2', 'Vehicle no. 7', 'Vehicle no. 10'],
    Icons.motorcycle,
  ),
  new Vehicle(
    'Cars',
    ['Vehicle no. 3', 'Vehicle no. 4', 'Vehicle no. 6'],
    Icons.directions_car,
  ),
];