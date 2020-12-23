import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ad_view.dart';



class SearchDisplay extends StatefulWidget {
  SearchDisplay(
      {Key key, this.auth, this.userId, this.logoutCallback, this.query})
      : super(key: key);
  final String query;
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => _SearchDisplayState(query: query);
}

class _SearchDisplayState extends State<SearchDisplay>
    with TickerProviderStateMixin {
  _SearchDisplayState({this.query});

  final String query;
  double _size = 140;
  final db = Firestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getList();
  }

  Widget getList() {
    if (query.trim() == "" || query == null) {
      return Center(
        child: Text(
          "Oops. Empty query string",
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
        ),
      );
    }
    var gridView = StreamBuilder<QuerySnapshot>(
        stream: db
            .collectionGroup("user_ads")
            .where("searchKeys", arrayContains: query.trim())
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("error getting ads with query");
            return Center(
              child: Text(
                "Error Occurred While Getting Ads",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data.documents.isEmpty) {
            return Center(
              child: Text(
                "No Ads Found",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
              ),
            );
          }
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
          return GridView.builder(
              itemCount: snapshot.data.documents.length,
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
                          image: snapshot.data.documents[index]['imageURLs'][0],
                        ),
                        Text(
                          snapshot.data.documents[index]['title'],
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "Rs " +
                              snapshot.data.documents[index]['price']
                                  .toString(),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    print("user id: "+snapshot.data.documents[index].reference.parent().parent().documentID);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdViewPage(
                          userId: widget.userId,
                          auth: widget.auth,
                          logoutCallback: widget.logoutCallback,
                          adUser: snapshot.data.documents[index].reference.parent().parent().documentID,
                          adLink: snapshot.data.documents[index].documentID,
                        ),
                      ),
                    );
                  },
                );
              });
        });

    return  gridView;
  }
}
