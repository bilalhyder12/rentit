import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_demo/data/ad_data.dart';

Future<bool> deleteAd(String adUser,String adID) async {
  bool status;
  final db = Firestore.instance;
  List<String> searchKeys;

  AdData data = AdData(
      uid: "",
      title: "",
      desc: "",
      category: "",
      province: "",
      city: "",
      price: 0,
      duration: "");

  await db
      .collection('ads')
      .document(adUser)
      .collection('user_ads')
      .document(adID)
      .get()
      .then((value) {
    data.uid = adID;
    value.data.forEach(
          (key, value) {
        if (key == "title") {
          data.title = value;
        } else if (key == "price") {
          data.price = double.parse(value.toString());
        } else if (key == "desc") {
          data.desc = value;
        } else if (key == "imageURLs") {
          data.imageURL = new List<String>();
          int i = 0;
          while (true) {
            try {
              data.imageURL.add(value[i]);
              i++;
            } catch (e) {
              break;
            }
          }
        } else if (key == "province") {
          data.province = value;
        } else if (key == "address") {
          data.address = value;
        } else if (key == "city") {
          data.city = value;
        } else if (key == "category") {
          data.category = value;
        } else if (key == "duration") {
          data.duration = value;
        } else if (key == "dateUploaded") {
          data.date = value.toDate();
        }
        else if(key == "searchKeys"){
          searchKeys = List.from(value);
        }
      },
    );
  }).timeout(Duration(seconds: 5));

  if(data.title.trim().isNotEmpty && searchKeys.isNotEmpty){
    DocumentReference docRef = db
        .collection("ads")
        .document(adUser).collection("deleted_ads").document(adID);
    await docRef
        .setData(
      {
        'category': data.category,
        'title': data.title,
        'desc': data.desc,
        'price': data.price,
        'duration': data.duration,
        'address':data.address,
        'province': data.province,
        'city': data.city,
        'imageURLs': data.imageURL,
        'dateUploaded':data.date,
        'searchKeys':searchKeys,
        'dateDelete':FieldValue.serverTimestamp(),
      },
    )
        .then(
          (doc) {
            print("ad moved to delete");
      },
    )
        .timeout(Duration(seconds: 5))
        .catchError(
          (error) {
        print("Error moving ad. Error: "+error.toString());
        status = false;
      },
    );

    if(docRef!=null) {
      await db
          .collection("app_data")
          .document(data.category)
          .setData(
        {
          adUser: FieldValue.arrayRemove([docRef.documentID.toString()]),
        },
        merge: true,
      )
          .then(
            (doc) {
          print("Category Updated");
          db
              .collection('ads')
              .document(adUser)
              .collection('user_ads')
              .document(adID).delete().then((value){
                print("Ad Deleted Successfully.");
                status = true;
              });
        },
      )
          .timeout(Duration(seconds: 8))
          .catchError(
            (error) {
          print("Could not remove from category. Error: "+error.toString());
          status = false;
        },
      );
    }
  }
  else{
    print("Could not delete ad.");
    status = false;
  }
  return status;
}
