import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_login_demo/services/update_details.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChatRoomList extends StatefulWidget {
  ChatRoomList({Key key, @required this.auth, @required this.userId, @required this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final String userId;
  final VoidCallback logoutCallback;

  @override
  State<StatefulWidget> createState() => new _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  final db = Firestore.instance;

  bool _userExists = true;

  @override
  void initState() {
    super.initState();
    doesUserAlreadyExist(widget.userId.toString());
  }

  void doesUserAlreadyExist(String uid) async {
    final QuerySnapshot result = await db
        .collection('Users')
        .where('UID', isEqualTo: uid)
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
            child: getChatList(),
          ),
        ],
      ),
    );
  }

  Widget getChatList() {
    var builder = StreamBuilder<QuerySnapshot>(
        stream: db.collection("chat_rooms").where('users',arrayContains: widget.userId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Rrror getting chat lists");
            return Center(
              child: Text(
                "Error Getting Your Chats",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
              ),
            );
          }
          if (!snapshot.hasData)
            return Center(
              child: Text(
                "No Active Chats",
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
          return getChatListItems(snapshot);
        });
    return builder;
  }

  getChatListItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData || snapshot.data.documents.isEmpty) {
      return Center(
        child: Text(
          "No Active Chats",
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
        ),
      );
    }
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: snapshot.data.documents
          .map(
            (doc) {
              // incomplete db.collection('ads').document(doc['sellerId']).collection("collectionPath");
                ListTile(title: Text("test")); 
              },
      )
          .toList(),
    );
  }

}