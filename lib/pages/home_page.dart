import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_login_demo/pages/post_ad.dart';
import 'package:flutter_login_demo/pages/profile_page.dart';
import 'package:flutter_login_demo/services/update_details.dart';
import 'package:flutter_login_demo/services/search_ad.dart';
import 'package:flutter_login_demo/views/boost_ad.dart';
import 'package:flutter_login_demo/views/chat_room_list.dart';
import 'package:flutter_login_demo/views/my_ads.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_login_demo/views/home.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = Firestore.instance;

  bool fabClicked = false;

  int _selectedTabIndex = 0;

  List<String> _pages = [
    "Home",
    "Messages",
    "MyAds",
  ];

  var fntSize = 30.0;
  var contHeight = 70.0;

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  void initialize() async {
//    if (await widget.auth.isEmailVerified()) {
    updateDetailsPopUp("init");
//    } else {
//      emailVerifyPopUp();
//    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  var statusHeight = 25.0;

  Widget navDrawer() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, statusHeight, 0, 0),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: contHeight,
              decoration: BoxDecoration(color: Colors.blue),
              child: ListTile(
                title: Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Rent ",
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: fntSize,
                          ),
                        ),
                        TextSpan(
                          text: "it",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: fntSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () => {
                  setState(
                    () {
                      contHeight = contHeight == 70.0 ? 150.0 : 70.0;
                      fntSize = fntSize == 30.0 ? 50.0 : 30.0;
                    },
                  )
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.verified_user,
                color: Colors.blue,
              ),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      userId: widget.userId,
                      auth: widget.auth,
                      logoutCallback: widget.logoutCallback,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.add_circle_sharp,
                color: Colors.blue,
              ),
              title: Text('Post Ad'),
              onTap: () {
                if (!fabClicked) {
                  setState(() {
                    fabClicked = true;
                  });
                  postAdButtonClick();
                }
              },
            ),
            ListTile(
              leading: Icon(
                Icons.aspect_ratio,
                color: Colors.blue,
              ),
              title: Text('Boost your Ad'),
              onTap: () => {
                showCupertinoModalBottomSheet(
                  context: context,
                  duration: Duration(milliseconds: 800),
                  builder: (context) => BoostAd(),
                )
              },
            ),
            ListTile(
              leading: Icon(
                Icons.border_color,
                color: Colors.blue,
              ),
              title: Text('Feedback'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.blue,
              ),
              title: Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.blue,
              ),
              title: Text('Logout'),
              onTap: signOut,
            ),
          ],
        ),
      ),
    );
  }

  var size = 30.0;

  Widget getView(String pageName) {
    if (pageName == "Home") {
      return HomeView();
    } else if (pageName == "MyAds") {
      return MyAds(
        userId: widget.userId,
        auth: widget.auth,
        logoutCallback: widget.logoutCallback,
      );
    } else if (pageName == "Messages") {
      return ChatRoomList(
        auth: widget.auth,
        userId: widget.userId,
        logoutCallback: widget.logoutCallback,
      );
      // Center(
//        child:
//        RaisedButton(
//          child: Text("TestUpload"),
//          onPressed: () {
//            testUpload();
//          } ,
//        )
//         child: Text(
//           "New Update messeages",
//           style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
//         ),
//       );
    }

    return Center(
      child: Text(
        "Error: Contact Developer.",
        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navDrawer(),
      appBar: AppBar(
        title: Text("Rent-It"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchAd(
                      userId: widget.userId,
                      auth: widget.auth,
                      logoutCallback: widget.logoutCallback));
            },
          )
        ],
      ),
      body: getView(_pages[_selectedTabIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: _changeIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'My Ads',
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: fabClicked ? Colors.grey : Colors.blue,
      //   tooltip: "Post Ad",
      //   onPressed: () {
      //     if (!fabClicked) {
      //       setState(() {
      //         fabClicked = true;
      //       });
      //       postAdButtonClick();
      //     }
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }

  void postAdButtonClick() async {
    //   if (await widget.auth.isEmailVerified()) {
    updateDetailsPopUp("fab");
//    } else {
//      emailVerifyPopUp();
//    }
  }

  Future<bool> doesUserAlreadyExist(String name) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('Users')
        .where('UID', isEqualTo: name)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }

  Widget dismissButton() {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 2.5, 0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.grey,
          child: Text(
            "Dismiss",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  emailVerifyPopUp() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text("Email Not Verified"),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Text(
                    "Please verify your email to lend or rent items.",
                  ),
                ),
              ),
              dismissButton(),
            ],
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide.none, borderRadius: BorderRadius.circular(25.0)),
        );
      },
    );
  }

  updateDetailsPopUp(String caller) async {
    bool userExists = await doesUserAlreadyExist(widget.userId);
    if (!userExists) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text("Details Not Updated"),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: Text(
                      "Please update your complete details to lend or rent items.",
                    ),
                  ),
                ),
                _getButtons(),
              ],
            ),
            shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(25.0)),
          );
        },
      );
    } else {
      if (caller == "fab") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdPost(
                    userId: widget.userId,
                    auth: widget.auth,
                    logoutCallback: widget.logoutCallback,
                  )),
        );
        setState(() {
          fabClicked = false;
        });
      }
    }
  }

  Widget _getButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 2.5, 0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.grey,
                child: Text(
                  "Dismiss",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(2.5, 0, 0, 0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.blue,
              child: Text(
                "Update",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                showCupertinoModalBottomSheet(
                  context: context,
                  duration: Duration(milliseconds: 800),
                  builder: (context) => UpdateDetails(
                    userId: widget.userId,
                    auth: widget.auth,
                    logoutCallback: widget.logoutCallback,
                  ),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => UpdateDetails(
                //       userId: widget.userId,
                //       auth: widget.auth,
                //       logoutCallback: widget.logoutCallback,
                //     ),
                //   ),
                // );
                //Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ],
    );
  }
}
