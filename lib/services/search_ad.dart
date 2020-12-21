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
    return (query == null || query.trim() == "")
        ? Container()
        : StreamBuilder<QuerySnapshot>(
            stream: db
                .collectionGroup("user_ads")
                .where("searchKeys", arrayContains: query.trim())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError || !snapshot.hasData) {
                return Container();
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return ListTile(
                    title: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                case ConnectionState.none:
                case ConnectionState.done:
                  return Container();
              }
              return ListView(
                children: snapshot.data.documents.map((DocumentSnapshot doc) {
                  return ListTile(
                    title: Text(doc['title']),
                    onTap: () {
                      query = doc['title'];
                    },
                  );
                }).toList(),
              );
            });
  }
}
