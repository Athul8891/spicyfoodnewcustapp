import 'package:zomatoui/resources.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum SingingCharacter { half, full }

class RestaurantItems extends StatefulWidget {
  final title;
  final price;

  RestaurantItems({this.title, this.price});

  @override
  _RestaurantItemsState createState() => _RestaurantItemsState();
}

class _RestaurantItemsState extends State<RestaurantItems> {
  bool isCounter = false;
  int count = 0;
  bool isCartVisible=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(width: 1, color: Colors.green)),
              alignment: Alignment.center,
              child: Icon(Icons.brightness_1, size: 9, color: Colors.green),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: boldTitleTxt),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Fast Food, North Indian",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "₹150",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
            flex: 1,
          ),
          Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/cat_images/cold_coffee.jpeg"),
                          fit: BoxFit.cover),
                    )),
              ),
              Positioned(
                  bottom: 1,
                  left: 10,
                  child: SizedBox(
                    height: 40,
                    width: 87,
                    child: isCounter
                        ? Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          if (count == 1) {
                                            isCounter = false;
                                          } else {
                                            count--;
                                          }
                                        });
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.green,
                                        size: 15,
                                      )),
                                ),
                                Text(
                                  count.toString(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          count++;
                                        });
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.green,
                                        size: 15,
                                      )),
                                ),
                              ],
                            ),
                          )
                        : Stack(
                            children: [
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isCounter = true;
                                      if (count > 0) {
                                        isCounter = true;
                                        //_showCustomizeMode(true);
                                        _showBottomSheet();
                                      } else {
                                        count++;
                                        isCounter = false;
                                      }
                                    });
                                  },
                                  style: addTextButton,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0, vertical: 4),
                                    child: Center(
                                      child: Text("ADD",
                                          style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 1.3,
                                              wordSpacing: 1,
                                              color: Colors.green,
                                              fontStyle: FontStyle.normal)),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 25,
                                child: Text(
                                  "customize",
                                  style: TextStyle(
                                      fontSize: 8, color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  SingingCharacter _character = SingingCharacter.half;

  void _showBottomSheet() {
    showMaterialModalBottomSheet(
        context: context,
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModelState) {
                return Container(
                  height: 520,
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/food_two.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    veg(),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Matar Paneer",
                                          style: appbar,
                                        ),
                                        Text(
                                          "Fast food, North Indian, Maxican",
                                          style:
                                              Theme.of(context).textTheme.headline6,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Text(
                                "Quantity",
                                style: titleBold,
                              ),
                              Text(
                                "Please select any one option",
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              RadioListTile<SingingCharacter>(
                                title: const Text(
                                  'Half ₹0',
                                  style: titleTxt,
                                ),
                                value: SingingCharacter.half,
                                groupValue: _character,
                                onChanged: (SingingCharacter value) {
                                  setModelState(() {
                                    _character = value;
                                  });
                                },
                              ),
                              RadioListTile<SingingCharacter>(
                                title: const Text(
                                  'Full ₹70',
                                  style: titleTxt,
                                ),
                                value: SingingCharacter.full,
                                groupValue: _character,
                                onChanged: (SingingCharacter value) {
                                  setModelState(() {
                                    _character = value;
                                  });
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "",
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                  SizedBox(
                                    width: 120,
                                    height: 50,
                                    child: Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: TextButton(
                                                onPressed: () {
                                                  setModelState(() {
                                                    if (count == 1) {
                                                      isCounter = false;
                                                      count = 0;
                                                      Navigator.pop(context);
                                                    } else {
                                                      count--;
                                                    }
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.green,
                                                  size: 15,
                                                )),
                                          ),
                                          Text(
                                            count.toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: TextButton(
                                                onPressed: () {
                                                  setModelState(() {
                                                    count++;
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.green,
                                                  size: 15,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          child: TextButton(
                             style: ButtonStyle(
                               backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                     (Set<MaterialState> states) {
                                   if (states.contains(MaterialState.pressed))
                                     return accentColor;
                                   return null; // Use the component's default.
                                 },
                               ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: allRadius,
                                   // side: BorderSide(color: accentColor),
                                  ),
                                ),
                              ),
                            onPressed: () {
                              setModelState((){
                                isCartVisible=true;
                                setState(() {
                                  isCartVisible=true;
                                });
                              });
                            },
                            child: Text(
                              "Add ₹150".toUpperCase(),
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ));
  }

  int value = 1;

}
