import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_login_demo/Widgets/featured_ads.dart';
import 'package:flutter_login_demo/pages/ad_display.dart';

class HomeView extends StatefulWidget {
  HomeView({
    Key key,
    this.auth,
    this.userId,
    this.logoutCallback,
  }) : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  int _expand = 1;

  final user = Firestore.instance.collection("Users");
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _expand == 1 ? FeaturedAds(auth: this.widget.auth,userId: this.widget.userId,logoutCallback: this.widget.logoutCallback) : Text(""),
        catTitle(),
        _expand == -1 ? fullCategoryList():categoryList(),
      ],
    );
  }

  Widget catTitle() {
    return Center(
      child: Text(
        "Categories",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 25.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void goToCategory(String selectedCat) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AdDisplay(
            userId: widget.userId,
            auth: widget.auth,
            logoutCallback: widget.logoutCallback,
            selectedCategory: selectedCat,
          )),
    );
  }

  Widget categoryList() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    iconSize: 80,
                    icon: Icon(
                      Icons.miscellaneous_services_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      goToCategory("Services");
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    iconSize: 80,
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,),
                    onPressed: () {
                      goToCategory("House");
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    iconSize: 80,
                    icon: Icon(
                      Icons.directions_car,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      goToCategory("Car");
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    iconSize: 80,
                    icon: Icon(
                      _expand == 1 ? Icons.expand_more:Icons.expand_less,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                       _expand *= -1;
                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget fullCategoryList() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    iconSize: 80,
                    icon: Icon(
                      Icons.miscellaneous_services_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      goToCategory("Services");
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    iconSize: 80,
                    icon: Icon(
                      Icons.laptop_mac,
                      color: Colors.white,),
                    onPressed: () {
                      goToCategory("Laptop");
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    iconSize: 80,
                    icon: Icon(
                      Icons.camera_enhance,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      goToCategory("Camera");
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    iconSize: 80,
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      goToCategory("House");
                    },
                  ),
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    iconSize: 80,
                    icon: Icon(
                      Icons.directions_car,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      goToCategory("Car");
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    iconSize: 80,
                    icon: Icon(
                      Icons.motorcycle,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      goToCategory("Bike");
                    },
                  ),
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    iconSize: 80,
                    icon: Icon(
                      Icons.more,
                      color: Colors.white,),
                    onPressed: () {
                      goToCategory("Other");
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    iconSize: 80,
                    icon: Icon(
                      _expand == 1 ? Icons.expand_more:Icons.expand_less,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _expand *= -1;
                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}
