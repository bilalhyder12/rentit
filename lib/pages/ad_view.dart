import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_login_demo/data/ad_data.dart';

class AdViewPage extends StatefulWidget {
  AdViewPage({Key key, this.auth, this.userId, this.logoutCallback, this.adUser,this.adLink})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String adUser;
  final String adLink;

  @override
  State<StatefulWidget> createState() => _AdViewPageState(adUser: adUser,adLink:adLink);
}

class _AdViewPageState extends State<AdViewPage>{
  _AdViewPageState({this.adUser,this.adLink});

  final String adUser;
  final String adLink;
  String name = "";
  String _dpImgURL = "";
  final db = Firestore.instance;


  AdData data=AdData(uid:"",title:"",desc:"",category:"",province:"",city:"",price:0,duration:"");

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async{
    await db.collection('ads').document(adUser).collection('user_ads').document(adLink).get().then((value){
      data.uid = adLink;
      value.data.forEach(
            (key, value) {
          if(key=="title") {
            data.title=value;
          }
          else if(key=="price") {
            data.price=double.parse(value.toString());
          }
          else if(key=="desc") {
            data.desc=value;
          }
          else if(key=="imageURLs") {
            data.imageURL = new List<String>();
            int i=0;
            while(true) {
              try{
                data.imageURL.add(value[i]);
                i++;
              }catch(e){
                break;
              }
            }

          }
          else if(key=="province") {
            data.province=value;
          }
          else if(key=="city") {
            data.city=value;
          }
          else if(key=="category") {
            data.category=value;
          }
          else if(key=="duration") {
            data.duration=value;
          }
        },
      );
    });

    StorageReference dpRef = FirebaseStorage.instance.ref().child(
      'dp/' + adUser,
    );
    dpRef.getDownloadURL().then(
        (value) {
          _dpImgURL = value;
        },
    ).catchError((e) {
      print("could not get user's display picture");
      print(e.toString());
    });
    String fName ="",lName="";
    await db.collection("Users").document(adUser).get().then(
          (value) {
        if (value.data.containsKey("fName")) {
          value.data.forEach(
                (key, value) {
              if (key == "fName") {
                fName = value;
              } else if (key == "lName") {
                lName = value;
              }}
          );

          name = fName + " " + lName;
          print(name);
        }
      },
    );
    setState(() {
      debugPrint("ad loaded");
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double _thickness = 5;
    return Scaffold(
      appBar: AppBar(
        title:data.title == "" ? Text("Loading Ad"): Text(data.title),
      ),
      body: data.title == "" ? Container():Container(
        padding: const EdgeInsets.all(10),
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: screenSize.height * 0.3,
                child: Swiper(
                  autoplay: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(
                      data.imageURL[index],
                      fit: BoxFit.fitHeight,
                    );
                  },
                  itemCount: data.imageURL.length,
                  // itemCount: 0,
                  viewportFraction: 0.8,
                  scale: 0.9,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(color: Colors.white),
                width: screenSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                         "Rs. "+data.price.toString(),
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          data.duration,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                         data.desc,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          data.city+","+data.province,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: Colors.grey[400],
                      thickness: _thickness,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Details",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        getDetailElement("City", data.city),
                        SizedBox(
                          height: 10,
                        ),
                        getDetailElement("Province", data.province),
                        SizedBox(
                          height: 10,
                        ),
                        getDetailElement("Category", data.category),

                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: Colors.grey[400],
                      thickness: _thickness,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Seller Description",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  getDP(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name.toUpperCase(),
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "View Profile",
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Colors.black54,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.navigate_next),
                              color: Colors.blue,
                              iconSize: 50,
                              onPressed: () {
                                debugPrint("Take to user profile");
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.grey[400],
                      thickness: _thickness,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Location",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.blue,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.location_on,
                              color: Colors.blue,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: screenSize.width,
                          height: 160,
                          child: Image.asset(
                            "assets/map.jpg",
                            fit: BoxFit.fitWidth,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getDetailElement(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget getDP() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: _dpImgURL != ""
              ? NetworkImage(_dpImgURL)
              : AssetImage("assets/user.png"),
        ),
      ),
    );
  }
}
