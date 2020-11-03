import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_login_demo/pages/update_details.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final picker = ImagePicker();
  final user = Firestore.instance.collection("Users");
  final ad = Firestore.instance.collection("ads");

  List adTitle = List();

  File _image;
  String _dpImgURL = "";

  bool _isLoading = true;
  bool _userExists = true;

  var fName = "";
  var lName = "";
  var name = "";

  var mNumber = "";
  var cnic = "";
  var dob = "";

  final nameFont = 30.0;
  final infoFont = 13.5;
  final dpSize = 110.0;

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
    } else {
      getData();
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
    } else if (fName == "") {
      return Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.blue,
          elevation: 15,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.white70,
            elevation: 20,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: showNameAndPic(),
            ),
          ),
          //TODO: show user's other details
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
            child: Container(
              height: 150,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 10,
                  ),
                  Container(
                    height: dpSize,
                    width: dpSize,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(doc["imageURLs"][0].toString()),
                      ),
                    ),
                  ),
                  Container(
                    width: 20,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          doc['title'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
//                      Container(
//                        width: 200,
//                        child: Text(doc['desc']),
//                      ),
                        Text(
                          "Rs. "+doc['price'].toString(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Widget getAdData() {
    var builder = StreamBuilder<QuerySnapshot>(
        stream: ad.document(widget.userId).collection("user_ads").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text("No Active Ads");
          return ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: getAdItems(snapshot),
          );
        });
    print("get ad completed");
    return builder;
//    print("3sdfsdfsdfsdf");
//    QuerySnapshot querySnapshot = await ad.document(widget.userId).collection("user_ads").getDocuments();
//    print("2sdfsdfsdfsdf");
//    print(querySnapshot.documents[0].data);
//    print("1sdfsdfsdfsdf");
  }

  Widget getDP() {
    return Container(
      height: dpSize,
      width: dpSize,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: _dpImgURL != ""
              ? NetworkImage(_dpImgURL)
              : NetworkImage("https://i.imgur.com/BoN9kdC.png"),
        ),
      ),
    );
  }

  Widget _displayInfoParam(String heading, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
              text: heading,
              style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: infoFont,
              )),
          TextSpan(
            text: value,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: infoFont,
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayName(String name) {
    return Text(
      name,
      style: TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: nameFont,
      ),
    );
  }

  Widget getInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _displayName(name),
        Container(
          height: 10.0,
        ),
        _displayInfoParam("CNIC: ", cnic),
        _displayInfoParam("Number: ", mNumber),
        _displayInfoParam("DOB: ", dob),
      ],
    );
  }

  Future chooseImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 200)
        .then((image) async {
      if (image != null && await image.exists()) {
        print("image selected");
        setState(() {
          _image = image;
        });
        //other code
      } else {
        print("image not selected");
        //other code
      }
    }).catchError((error) {
      print("Error: " + error.toString());
    });
  }

  Future uploadImage() async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('dp/' + widget.userId);
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print(_image);
    storageReference.getDownloadURL().then(
      (fileURL) {
        setState(
          () {
            _dpImgURL = fileURL;
          },
        );
      },
    );
  }

  void selectAndUpload() async {
    chooseImage().then((result) {
      if (_image != null) {
        uploadImage();
      }
    });
  }

  Widget uploadButton() {
    return FlatButton(
      child: Icon(Icons.add_a_photo),
      onPressed: () {
        selectAndUpload();
      },
    );
  }

  Widget showNameAndPic() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            getDP(),
            uploadButton(),
          ],
        ),
        getInfo(),
      ],
    );
  }

  void getData() async {
    await user.document(widget.userId).get().then(
      (value) {
        if (value.data.containsKey("fName")) {
          value.data.forEach(
            (key, value) {
              if (key == "fName") {
                fName = value;
              } else if (key == "lName") {
                lName = value;
              } else if (key == "cnic") {
                cnic = value;
              } else if (key == "mNumber") {
                mNumber = value;
              } else if (key == "dob") {
                dob = value;
              }
            },
          );
          setState(() {
            name = fName + " " + lName;
          });
        }
      },
    );
    setState(() {
      _isLoading = false;
    });
    StorageReference dpRef = FirebaseStorage.instance.ref().child(
          'dp/' + widget.userId,
        );
    dpRef.getDownloadURL().then(
      (value) {
        setState(
          () {
            _dpImgURL = value;
          },
        );
      },
    ).catchError((e) {
      print(e.toString());
    });
  }
}
