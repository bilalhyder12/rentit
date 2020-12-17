import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchAd extends SearchDelegate<String> {
  final db = Firestore.instance;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = "";
          }
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
        child: Text(
      query,
      style: TextStyle(fontSize: 20),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: db
            .collectionGroup("user_ads")
            .where("searchKey", arrayContains: query).snapshots(),
        builder: (context, snapshot){
          return ListView(children: snapshot.data.documents.map((DocumentSnapshot doc){
            return ListTile(
              title: Text(doc['title']),
            );
          }).toList(),);
        });
  }
}
