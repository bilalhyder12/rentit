import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_login_demo/services/update_details.dart';
import 'package:flutter_login_demo/services/string_caps.dart';
import 'chat_room.dart';

class ChatRoomList extends StatefulWidget {
  ChatRoomList(
      {Key key,
      @required this.auth,
      @required this.userId,
      @required this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final String userId;
  final VoidCallback logoutCallback;

  @override
  State<StatefulWidget> createState() => new _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  final db = Firestore.instance;

  String userName = "";
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
    } else {
      userName =
          documents.first.data["fName"] + " " + documents.first.data["lName"];
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
        stream: db
            .collection("chat_rooms")
            .where('users', arrayContains: widget.userId)
            .orderBy('lastMessage.time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Error getting chat lists");
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

  String getInitials(String name) {
    List<String> nameSeparated;
    nameSeparated = name.split(" ");
    String initials = "";
    int i = 0;
    for (String separate in nameSeparated) {
      if (i >= 2) {
        break;
      }
      initials += separate.substring(0, 1).toUpperCase();
      i++;
    }
    return initials;
  }

  String getDate(DateTime messagedAt) {
    final currDate = DateTime.now();
    if (messagedAt.day == currDate.day &&
        messagedAt.month == currDate.month &&
        messagedAt.year == currDate.year) {
      return DateFormat.jm().format(messagedAt);
    }
    else if((currDate.day - messagedAt.day <= 1) &&
        messagedAt.month == currDate.month &&
        messagedAt.year == currDate.year){
      return "Yesterday";
    }
    return DateFormat('d-M-yy').format(messagedAt);
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
      children: snapshot.data.documents.map(
        (doc) {
          return ListTile(
            dense: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoom(
                    userId: widget.userId,
                    auth: widget.auth,
                    logoutCallback: widget.logoutCallback,
                    chatRoomId: doc.documentID,
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              child: userName.contains(doc["buyerName"])
                  ? Text(
                      getInitials(
                        doc["sellerName"],
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      getInitials(
                        doc["buyerName"],
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
              backgroundColor: Colors.blue,
            ),
            title: Text(
              doc["adTitle"].toString().capitalizeFirstofEach,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87.withOpacity(0.65),
              ),
            ),
            subtitle: doc["lastMessage"]["senderId"] == widget.userId
                ? RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: 'You: ',
                      style: TextStyle(color: Colors.black87),
                      children: <TextSpan>[
                        TextSpan(
                          text: doc["lastMessage"]["message"],
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : Text(
                    doc["lastMessage"]["message"],
                    style: TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
            trailing: Text(
              getDate(
                doc['lastMessage']['time'].toDate(),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
