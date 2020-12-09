import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_demo/services/authentication.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({Key key, this.auth, this.userId, this.logoutCallback, this.sellerId,this.adId})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String sellerId;
  final String adId;

  @override
  State<StatefulWidget> createState() => _ChatRoomState(sellerId: sellerId,adId: adId);
}

class _ChatRoomState extends State<ChatRoom> with TickerProviderStateMixin {
  _ChatRoomState({this.sellerId,this.adId});

  final String sellerId;
  final String adId;

  final db = Firestore.instance;

  @override
  void initState() {
    super.initState();
    createOrGetRoom();
  }

  void createOrGetRoom(){

  }

  @override
  Widget build(BuildContext context) {

    throw UnimplementedError();
  }
}