import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_login_demo/data/ad_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_login_demo/pages/home_page.dart';
import 'dart:io';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImages extends StatefulWidget {
  UploadImages(
      {Key key, this.data, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  final AdData data;

  @override
  State<StatefulWidget> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  final db = Firestore.instance;
  bool isFirstAd = false;

  bool isUploading = false;
  bool _userAds = true;

  List<Asset> images = List<Asset>();
  List<String> imageURLs = List<String>();
  List<String> imagesPath=List<String>();

  String _error = "";

  Widget _showImagesInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        children: <Widget>[
          _error.isEmpty
              ? Container()
              : Center(
                  child: Text(_error),
                ),
          images.isEmpty ? Container() : _imagePreview(),
          RaisedButton(
            child: Text("Select/Deselect Images"),
            onPressed: loadAssets,
          ),
          _showSubmitButton(),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showCircularProgress() {
    if (isUploading) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showSubmitButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        width: 150.0,
        child: RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.blue,
          child: Text(
            "Post Ad",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          onPressed: isUploading ? null : uploadAd,
        ),
      ),
    );
  }

  void uploadAd() {
    //TODO: implement upload
    if (images.isEmpty) {
      showErrorDialog("empty");
      return;
    } else {
      uploadInfoToFirebase();
    }
  }

  Widget _showDismissButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        width: 150.0,
        child: RaisedButton(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.grey,
          child: Text(
            "Dismiss",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          onPressed: Navigator.of(context).pop,
        ),
      ),
    );
  }

  Widget _returnButton() {
    return SizedBox(
      width: 100,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.blue,
        child: Text(
          "Return",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                userId: widget.userId,
                auth: widget.auth,
                logoutCallback: widget.logoutCallback,
              ),
            ),
            (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }

  void showSuccessfulDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text("Success!"),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Text(
                    "Ad Posted Successfully.",
                  ),
                ),
              ),
              Center(child: _returnButton()),
            ],
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide.none, borderRadius: BorderRadius.circular(25.0)),
        );
      },
    );
  }

  void showErrorDialog(String reason) {
    String msg = '';
    if (reason == 'time') {
      msg = 'Network Time Out';
    } else if (reason == 'empty') {
      msg = 'Please Select At Least One Picture';
    }
    else if(reason=='no_connectivity') {
      msg = 'No Internet Connectivity Found';
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("Error!")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Text(
                    msg,
                  ),
                ),
              ),
              Center(child: _showDismissButton()),
            ],
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide.none, borderRadius: BorderRadius.circular(25.0)),
        );
      },
    );
  }

  Widget _imagePreview() {
    return Container(
      height: 290,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: buildGridView(),
      //),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return GestureDetector(
          onTap: () => print("image at index $index tapped"),
          onDoubleTap: () => print("image at index $index double tapped"),
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = '';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 6,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(
      () {
        images = resultList;
        _error = error;
      },
    );
  }

  Widget printInfo() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("uid"),
          subtitle: Text(widget.data.uid ?? "null"),
        ),
        ListTile(
          title: Text("title"),
          subtitle: Text(widget.data.title ?? "null"),
        ),
        ListTile(
          title: Text("desc"),
          subtitle: Text(widget.data.desc ?? "null"),
        ),
        ListTile(
          title: Text("category"),
          subtitle: Text(widget.data.category ?? "null"),
        ),
        ListTile(
          title: Text("province"),
          subtitle: Text(widget.data.province ?? "null"),
        ),
        ListTile(
          title: Text("city"),
          subtitle: Text(widget.data.city ?? "null"),
        ),
        ListTile(
          title: Text("price"),
          subtitle: Text(widget.data.price.toString() ?? "null"),
        ),
      ],
    );
  }

  Future<bool> createUserAd(String id) async {
    await db
        .collection("ads")
        .document(widget.userId)
        .setData({
          'UID': widget.userId,
          'counter': FieldValue.increment(1),
        }, merge: true)
        .then((value) {
          print('counter updated');
          _userAds = true;
        })
        .timeout(Duration(seconds: 5))
        .catchError((e) {
          print("error while creating");
          print(e.toString());
          _userAds = false;
        });

    return _userAds;
  }

  Future<bool> uploadImagesToStorage() async {
    for (int i = 0; i < images.length; i++) {
      var path = await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      imagesPath.add(path);
    }

    for(int i=0;i<images.length;i++) {
      File _image = File(imagesPath[i]);
      bool fileExists = await _image.exists();
      if(fileExists) {
        StorageReference storageReference =
        FirebaseStorage.instance.ref().child('ads/' + widget.userId+"/"+images[i].name);
        StorageUploadTask uploadTask = storageReference.putFile(_image);
        await uploadTask.onComplete;
        print(_image);
        await storageReference.getDownloadURL().then(
              (fileURL) {
            imageURLs.add(fileURL.toString());
          },
        ).catchError((e)=> print(e));
      }
      else {
        print('file load error. Name: '+images[i].name);
      }
    }
    return true;
  }

  void uploadInfoToFirebase() async {
    //TODO: uploading to firebase
    setState(() {
      isUploading = true;
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected to internet. Proceeding upload');
        await createUserAd(widget.userId);
        await uploadImagesToStorage().then((value) async {
          DocumentReference docRef = db
              .collection("ads")
              .document(widget.userId).collection("user_ads").document();
          await docRef
              .setData(
            {
              'category': widget.data.category,
              'title': widget.data.title,
              'desc': widget.data.desc,
              'price': widget.data.price,
              'duration': widget.data.duration,
              'province': widget.data.province,
              'city': widget.data.city,
              'imageURLs':imageURLs,
              'dateUploaded':FieldValue.serverTimestamp(),
            },
          )
              .then(
                (doc) {
                  print("Ad Uploaded");
                  showSuccessfulDialog();
                },
              )
              .timeout(Duration(seconds: 5))
              .catchError(
                (error) {
              showErrorDialog("time");
              print("Ad upload error");
              print(error);
            },
          );

          //TODO: Update category array
          if(docRef!=null){
            await db
                .collection("app_data")
                .document(widget.data.category)
                .setData(
              {
                widget.userId: FieldValue.arrayUnion([docRef.documentID.toString()]),
              },
              merge: true,
            )
                .then(
                  (doc) {
                print("Category Updated");
              },
            )
                .timeout(Duration(seconds: 8))
                .catchError(
                  (error) {
                showErrorDialog("time");
                print("Ad upload error");
                print(error);
              },
            );
          }
        });
        setState(() {
          isUploading = false;
        });
      }
    } on SocketException catch (_) {
      print('error: no internet connectivity');
      showErrorDialog('no_connectivity');
      return;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Images"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: _showImagesInput(),
      ),
    );
  }
}
