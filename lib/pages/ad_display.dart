import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_login_demo/services/string_caps.dart';
import 'package:flutter_login_demo/data/ad_short.dart';
import 'package:flutter_login_demo/pages/ad_view.dart';

class AdDisplay extends StatefulWidget {
  AdDisplay(
      {Key key,
      this.auth,
      this.userId,
      this.logoutCallback,
      this.selectedCategory})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String selectedCategory;

  @override
  State<StatefulWidget> createState() =>
      _AdDisplayState(selectedCategory: selectedCategory);
}

class _AdDisplayState extends State<AdDisplay> with TickerProviderStateMixin {
  _AdDisplayState({this.selectedCategory});
  TabController tabController;
  final String selectedCategory;
  double _size = 140;
  bool _isLoading = true;
  final db = Firestore.instance;

  List<String> adLinks = new List();
  List<String> user = new List();
  List<AdShort> ads = new List();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    //Get links of ads for selected category
    await db
        .collection('app_data')
        .document(selectedCategory)
        .get()
        .then((value) {
      value.data.forEach(
        (key, value) {
          var test = value;
          for (int i = 0; i < test.length; i++) {
            user.add(key);
            adLinks.add(test[i]);
          }
        },
      );
    });
    print("Total ads of $selectedCategory: " + user.length.toString());
    //TODO: Get the ads (links) from database

    for (int i = 0; i < adLinks.length; i++) {
      await db
          .collection('ads')
          .document(user[i])
          .collection('user_ads')
          .document(adLinks[i])
          .get()
          .then((value) {
        AdShort temp = new AdShort();
        temp.uid = adLinks[i];
        value.data.forEach(
          (key, value) {
            if (key == "title") {
              temp.title = value;
            } else if (key == "price") {
              print(value);
              temp.price = double.parse(value.toString());
            } else if (key == "imageURLs") {
              temp.thumbnail = value[0];
            }
          },
        );
        ads.add(temp);
      });
    }
    print("loaded");
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var toDisplay;
    _isLoading == true ? toDisplay = getShimmer() : toDisplay = getList();
    return toDisplay;
  }

  Widget getList() {
    tabController = TabController(length: 2, vsync: this);

    var tabBarItem = TabBar(
      tabs: [
        Tab(
          icon: Icon(Icons.grid_on),
        ),
        Tab(
          icon: Icon(Icons.list),
        ),
      ],
      controller: tabController,
      indicatorColor: Colors.white,
    );

    var listItem = ListView.builder(
      itemCount: user.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Card(
            elevation: 5.0,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text("Title $index"),
            ),
          ),
          onTap: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                child: CupertinoAlertDialog(
                  title: Column(
                    children: <Widget>[
                      Text("ListView"),
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  content: Text("Selected Item $index"),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"))
                  ],
                ));
          },
        );
      },
    );

    var gridView = GridView.builder(
        itemCount: user.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Card(
              elevation: 5.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FadeInImage.memoryNetwork(
                    width: _size - 20,
                    height: _size - 20,
                    fit: BoxFit.contain,
                    placeholder: kTransparentImage,
                    image: ads[index].thumbnail,
                  ),
                  Padding(
                    child: Text(
                      ads[index].title.capitalizeFirstofEach,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  ),
                  Text("Rs " + ads[index].price.round().toString()),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdViewPage(
                          userId: widget.userId,
                          auth: widget.auth,
                          logoutCallback: widget.logoutCallback,
                          adUser: user[index],
                          adLink: adLinks[index],
                        )),
              );
            },
          );
        });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Showing all '$selectedCategory' ads"),
          bottom: tabBarItem,
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            gridView,
            listItem,
          ],
        ),
      ),
    );
  }

  Widget getShimmer() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Showing all '$selectedCategory' ads"),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: _isLoading,
                child: GridView.builder(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    itemCount: 8,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: InkResponse(
                          child: Container(
                            height: _size,
                            width: _size,
                          ),
                          onTap: () {
                            print(index);
                          },
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
