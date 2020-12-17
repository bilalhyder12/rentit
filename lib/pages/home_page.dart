import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_login_demo/pages/post_ad.dart';
import 'package:flutter_login_demo/pages/update_details.dart';
import 'package:flutter_login_demo/services/search_ad.dart';
import 'package:flutter_login_demo/views/profile.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_login_demo/views/home.dart';
import 'payment_page.dart';

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

  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";

  int _selectedTabIndex = 0;

  List<String> _pages = [
    "Home",
    "Messages",
    "Profile",
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
              leading: Icon(Icons.verified_user),
              title: Text('Profile'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.border_color),
              title: Text('Feedback'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Your Ads'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.aspect_ratio),
              title: Text('Boost your Ad'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text("Payment Page "),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>PaymentScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
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
    }
    else if (pageName == "Profile") {
      return ProfileView(
        userId: widget.userId,
        auth: widget.auth,
        logoutCallback: widget.logoutCallback,
      );
    }
    else if (pageName == "Messages") {
      return Center(
//        child:
//        RaisedButton(
//          child: Text("TestUpload"),
//          onPressed: () {
//            testUpload();
//          } ,
//        )
        child: Text(
          "New Update messeages",
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
        ),
      );
    }

    return Text("Error: 404");
  }

//  void testUpload() async {
//   DocumentReference df = db
//        .collection("app_data")
//        .document();
//   df.
//        setData({
//          "test":"testing"
//      },
//    )
//        .then(
//          (doc) {
//        print("Ad Uploaded");
//      },
//    )
//        .timeout(Duration(seconds: 5))
//        .catchError(
//          (error) {
//        print("Ad upload error: "+error.toString());
//
//      },
//    );
//
//   if(df == null) {
//     print("-------------is null");
//   }
//   else{
//     print("-------------is not null");
//     print("-------------id is: "+df.documentID.toString());
//   }
//  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery,
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: navDrawer(),
      appBar: AppBar(
        title: Text("Rent-It"),
        actions: [IconButton(
          icon: Icon(Icons.search,color: Colors.white,),
          onPressed: (){
            showSearch(context: context, delegate: SearchAd());
          },
        )],
      ),
      body: getView(_pages[_selectedTabIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: _changeIndex,
        type: BottomNavigationBarType.fixed,
        // this will be set when a new tab is tapped
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
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: fabClicked ? Colors.grey: Colors.blue,
        tooltip: "Post Ad",
        onPressed: () {
          if(!fabClicked) {
            setState(() {
              fabClicked = true;
            });
            postAdButtonClick();
          }

        },
        child: Icon(Icons.add),
      ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateDetails(
                      userId: widget.userId,
                      auth: widget.auth,
                      logoutCallback: widget.logoutCallback,
                    ),
                  ),
                );
                //Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ],
    );
  }
}
