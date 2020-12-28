import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_login_demo/services/update_details.dart';
import 'package:intl/intl.dart';
import 'package:flutter_login_demo/services/string_caps.dart';
import 'package:flutter_login_demo/services/delete_ads.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MyAds extends StatefulWidget {
  MyAds({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final String userId;
  final VoidCallback logoutCallback;

  @override
  State<StatefulWidget> createState() => new _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  final ad = Firestore.instance.collection("ads");

  bool _userExists = true;
  bool isDeleting = false;

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
              showCupertinoModalBottomSheet(
                context: context,
                duration: Duration(milliseconds: 800),
                builder: (context) => UpdateDetails(
                  userId: widget.userId,
                  auth: widget.auth,
                  logoutCallback: widget.logoutCallback,
                ),
              );
              //Navigator.of(context).pop();
            },
          ),
        ],
      ));
    }
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
    if (!snapshot.hasData || snapshot.data.documents.isEmpty) {
      return Center(
        child: Text(
          "No Active Ads",
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
        ),
      );
    }
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: snapshot.data.documents
          .map(
            (doc) => Container(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.grey, width: 1),
                ),
                color: Colors.white,
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
                                color: Colors.blue,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                    doc["imageURLs"][0].toString()),
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
                                    doc['title']
                                        .toString()
                                        .capitalizeFirstofEach,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Rs. ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        doc['price'].toString(),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    doc['duration'].toString(),
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
                      right: 10,
                      child: Text(
                        DateFormat.yMMMd('en_US')
                            .format(doc['dateUploaded'].toDate())
                            .toString(),
                        style: TextStyle(
                            fontStyle: FontStyle.normal, color: Colors.black),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 10,
                      child: IconButton(
                        icon: Icon(
                          CupertinoIcons.delete,
                          color: Colors.black,
                        ),
                        disabledColor: Colors.grey,
                        onPressed: isDeleting == true
                            ? null
                            : () {
                                setState(() {
                                  isDeleting = true;
                                });
                                deleteAd(
                                  doc.reference.parent().parent().documentID,
                                  doc.documentID.toString(),
                                ).then(
                                  (value) {
                                    setState(() {
                                      isDeleting=false;
                                    });
                                  },
                                );
                                // print("adId: "+doc.documentID.toString());
                                // print("userIDL "+doc.reference.parent().parent().documentID);
                              },
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10.0,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget getAdData() {
    var builder = StreamBuilder<QuerySnapshot>(
        stream: ad.document(widget.userId).collection("user_ads").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("error getting ads with query");
            return Center(
              child: Text(
                "Error Getting Ads",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
              ),
            );
          }
          if (!snapshot.hasData)
            return Center(
              child: Text(
                "No Active Ads",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
              ),
            );
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                width: 50,
                height: 50,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case ConnectionState.none:
            case ConnectionState.done:
              return Container();
          }
          return getAdItems(snapshot);
        });
    return builder;
  }
}
