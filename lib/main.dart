import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_test/groups_list_add.dart';
import 'movie_list.dart';
//import 'login_page.dart';
import 'package:tmdb_test/login_page.dart';
import 'transition_route_observer.dart';
import 'auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    future: Firebase.initializeApp();
    return new MaterialApp(
      title: 'MatchFlix',
      home: LoginPage(), //MovieList(),//LoginScreen(),//WebViewExample();
      navigatorObservers: [TransitionRouteObserver()],
      routes: {
        //LoginScreen.routeName: (context) => LoginScreen(),
        //DashboardScreen.routeName: (context) => DashboardScreen(),
      },
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
            modalBackgroundColor: Colors.white.withOpacity(0.87)),
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.black12,
        cursorColor: Colors.white,
        textTheme: TextTheme(
          display2: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            color: Colors.white,
          ),
          button: TextStyle(
            fontFamily: 'OpenSans',
          ),
          subhead: TextStyle(fontFamily: 'NotoSans'),
          body1: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),

    );
  }
}