import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_login_demo/pages/root_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'rentit',
        debugShowCheckedModeBanner: false,
        theme:
        ThemeData(
          primarySwatch: Colors.blue,
        ),
        // ThemeData(
        //   primaryColor: Color(0xff145C9E),
        //   scaffoldBackgroundColor: Color(0xff1F1F1F),
        //   accentColor: Color(0xff007EF4),
        //   fontFamily: "OverpassRegular",
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        //   textTheme: Theme.of(context).textTheme.apply(
        //     bodyColor: Colors.white,
        //     displayColor: Colors.white,
        //   ),
        // ),
        home: RootPage(auth: Auth()),
    );
  }
}
