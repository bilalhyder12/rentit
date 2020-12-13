import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/services/authentication.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom(
      {Key key,
      this.auth,
      this.userId,
      this.logoutCallback,
      this.sellerId,
      this.adId})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String sellerId;
  final String adId;

  @override
  State<StatefulWidget> createState() =>
      _ChatRoomState(sellerId: sellerId, adId: adId);
}

class _ChatRoomState extends State<ChatRoom> with TickerProviderStateMixin {
  _ChatRoomState({this.sellerId, this.adId});

  final String sellerId;
  final String adId;

  final db = Firestore.instance;

  @override
  void initState() {
    super.initState();
    createChatRoom();
  }

  Future<bool> createChatRoom() async {
    bool _created;
    await db
        .collection("chat_rooms")
        .document(widget.userId.toString()+'_'+sellerId)
        .collection(adId)
        .document("test")
        .setData({
          'UID': widget.userId,
          'counter': FieldValue.increment(1),
        }, merge: true)
        .then((value) {
          print('counter updated');
          _created = true;
        })
        .timeout(Duration(seconds: 5))
        .catchError((e) {
          print("error while creating");
          print(e.toString());
          _created = false;
        });

    return _created;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat 1"),
      ),
      body: SizedBox.expand(
        child: Container(
          child: Column(
            children: [Text("message 1"), Text("message 1"), TextField()],
          ),
        ),
      ),
    );
  }
}
