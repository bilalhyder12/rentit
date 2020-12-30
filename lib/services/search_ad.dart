import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_demo/pages/search_display.dart';

class SearchAd extends SearchDelegate<String> {
  final db = Firestore.instance;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.white,
        ),
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

  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: theme.primaryColor,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      //Not working
      primaryTextTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchDisplay(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return (query == null || query.trim() == "")
        ? Container()
        : StreamBuilder<QuerySnapshot>(
            stream: db
                .collectionGroup("user_ads")
                .where("searchKeys", arrayContainsAny: query.trim().split(" "))
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
                    title:  Text(
                        doc['title'],
                        overflow: TextOverflow.ellipsis,
                      ),
                    leading: IconButton(
                      icon: Icon(CupertinoIcons.search,),
                      onPressed: () {
                        query = doc['title'];
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(CupertinoIcons.arrow_up,),
                      onPressed: () {
                        query = doc['title'];
                      },
                    ),
                    onTap: () {
                      query = doc['title'];
                    },
                  );
                }).toList(),
              );
            });
  }
}
