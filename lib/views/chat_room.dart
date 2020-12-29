import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom(
      {Key key,
      @required this.auth,
      @required this.userId,
      @required this.logoutCallback,
      @required this.chatRoomId})
      : super(key: key);

  final BaseAuth auth;
  final String userId;
  final VoidCallback logoutCallback;
  final String chatRoomId;

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget chatMessages() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("chat_rooms")
            .document(widget.chatRoomId)
            .collection("chats")
            .orderBy("time")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          if (snapshot.hasError) {
            print("error getting chats");
            return Center(
              child: Text(
                "Error Getting Chats. Please Refresh",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
              ),
            );
          }
          if (!snapshot.hasData ||
              (snapshot.hasData && snapshot.data.documents.length == 0))
            return Container();
          return ListView.builder(
            padding: EdgeInsets.only(bottom: 75,top:5),
            scrollDirection: Axis.vertical,
            // shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return MessageTile(
                message: snapshot.data.documents[index]["message"],
                sendByMe:
                    snapshot.data.documents[index]["senderId"] == widget.userId
                        ? true
                        : false,
                sentDate: snapshot.data.documents[index]["time"].toDate(),
              );
            },
          );
        });
  }

  void sendMessage(String message) {
    if (message.trim().isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "senderId": widget.userId,
        "message": message.trim(),
        'time': DateTime.now(),
        "seen": false,
      };

      Firestore.instance
          .collection("chat_rooms")
          .document(widget.chatRoomId)
          .collection("chats")
          .add(messageMap)
          .then(
            (value) {
              Firestore.instance.collection("chat_rooms").document(widget.chatRoomId).updateData({
                "lastMessage":messageMap,
              });
            },
          )
          .catchError(
            (error) {
              print("could not send message");
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // int _numLines = 0;
    // int _numChar = 0;

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Chat"),
      ),
      body: GestureDetector(
        child: Container(
          child: Stack(
            children: [
              chatMessages(),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5,),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: messageEditingController,
                          onChanged: (text) {
                          },
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.4),
                            //   labelText: "Message",
                            //   labelStyle: TextStyle(
                            //   color: Colors.white.withOpacity(0.9),
                            //   fontSize: 16,
                            // ),
                            // counterText: messageEditingController.text.length
                            //         .toString() +
                            //     " characters",
                            border: InputBorder.none,
                            // border: OutlineInputBorder(borderSide: BorderSide()),
                          ),
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            sendMessage(messageEditingController.text);
                            messageEditingController.clear();
                            FocusScope.of(context).unfocus();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Colors.white.withOpacity(0.5)),
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.grey[600],
                                      Colors.grey[700],
                                      // Colors.blue[600], Colors.blue[700]
                                    ],
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight),
                                borderRadius: BorderRadius.circular(40)),
                            padding: EdgeInsets.all(12),
                            child: Image.asset(
                              "assets/send.png",
                              height: 25,
                              width: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final DateTime sentDate;

  MessageTile({
    @required this.message,
    @required this.sendByMe,
    @required this.sentDate,
  });

  @override
  Widget build(BuildContext context) {
    double _bubbleRoundness = 20;

    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(width: 1, color: Colors.black),
      // ),
      padding: EdgeInsets.only(
          top: 1,
          bottom: 1,
          left: sendByMe ? 50 : 10,
          right: sendByMe ? 10 : 50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: sendByMe ? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Container(
            margin: sendByMe
                ? EdgeInsets.only(
                    left: 20,
                  )
                : EdgeInsets.only(
                    right: 20,
                  ),
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 10,
              right: 10,
            ),

            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: sendByMe ? Colors.white : Colors.black,
              ),
              borderRadius: sendByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(_bubbleRoundness),
                      topRight: Radius.circular(_bubbleRoundness),
                      bottomLeft: Radius.circular(_bubbleRoundness))
                  : BorderRadius.only(
                      topLeft: Radius.circular(_bubbleRoundness),
                      topRight: Radius.circular(_bubbleRoundness),
                      bottomRight: Radius.circular(_bubbleRoundness)),
              gradient: LinearGradient(
                colors: sendByMe
                    ? [Colors.blue[400], Colors.blue[600]]
                    : [
                        // Colors.grey[600],
                        // Colors.grey[900],
                        Colors.white70,
                        Colors.white
                      ],
              ),
            ),
            child: Text(
              message,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: sendByMe ? Colors.white.withOpacity(1) : Colors.black,
                  fontSize: 16,
                  fontFamily: 'MuktaRegular',
                  fontWeight: FontWeight.w300,
                height: 1.1,
              ),
            ),
          ),
          Container(
            padding: sendByMe
                ? const EdgeInsets.only(right: 4)
                : const EdgeInsets.only(left: 4),
            alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              DateFormat.Hm('en_US').format(sentDate).toString(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
