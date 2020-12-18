import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_login_demo/pages/update_details.dart';

class MyAds extends StatefulWidget {
  MyAds({Key key, this.auth, this.userId}) : super(key: key);

  final BaseAuth auth;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  final ad = Firestore.instance.collection("ads");

  List adTitle = List();
  bool _userExists = true;

  @override
  void initState() {
    super.initState();
    doesUserAlreadyExist(widget.userId.toString());
  }

  void doesUserAlreadyExist(String name) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('Users')
        .where('UID', isEqualTo: name)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length != 1) {
      setState(
        () {
          _userExists = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_userExists) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Please add your complete details",
            style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.blue,
            child: Text(
              "Update",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateDetails(
                    userId: widget.userId,
                  ),
                ),
              );
              //Navigator.of(context).pop();
            },
          ),
        ],
      ));
    }
    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        children: <Widget>[
          Expanded(
            child: getAdData(),
          ),
        ],
      ),
    );
  }

  getAdItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map(
          (doc) => Card(
            color: Colors.white70,
            child: Stack(
              children: [
                Container(
                  height: 150,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 10,
                      ),
                      Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(doc["imageURLs"][0].toString()),
                          ),
                        ),
                      ),
                      Container(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                doc['title'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              Container(
                                height: 10,
                              ),
                              Text(
                                "Rs. " + doc['price'].toString(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Text("Date Added"),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget getAdData() {
    var builder = StreamBuilder<QuerySnapshot>(
        stream: ad.document(widget.userId).collection("user_ads").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("error getting ads with query");
            return Container();
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );

            case ConnectionState.none:
            case ConnectionState.done:
              return Container();
          }
          if (!snapshot.hasData) return Text("No Active Ads");
          return ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: getAdItems(snapshot),
          );
        });
    return builder;
  }
}
