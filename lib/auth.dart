import 'dart:async';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'movie_list.dart';

var tmdbAPIkey = 'PUT YOUR API KEY HERE';
var askForToken_url = 'https://api.themoviedb.org/3/authentication/token/new?api_key='+'${tmdbAPIkey}';
var token = '';
var authorizeToken_url = 'https://www.themoviedb.org/authenticate/' + token;
var getSessionID_url = 'https://api.themoviedb.org/3/authentication/session/new?api_key=' + tmdbAPIkey + '&request_token=' + token;
var sessionID = '';
var getUser_url = 'https://api.themoviedb.org/3/account?api_key=' + tmdbAPIkey + '&session_id=' + sessionID;
var userID = '';
var username = '';
var avatar_path = '';
var country = '';

var loggedin = false;
var authorized = false;
var sessionStarted = false;
var current_url;




Future<String> get _localPath async { // find folder
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}
Future<File> get _localFile async { // create file
  final path = await _localPath;
  return File('$path/user.txt');
}
Future<File> writeUser(userID, username, avatar_path, country) async { // write to file
  final file = await _localFile;

  // Write the file.
  return file.writeAsString(
      '$userID\n'
      '$username\n'
      '$avatar_path\n'
      '$country\n'
      '$sessionID'
  );

  print("FILE WRITTEN ! ! !");
}
Future<List> readUser() async { // read from file
  try {
    final file = await _localFile;

    // Read the file.
    String contents = await file.readAsString();
    var singleElements = LineSplitter.split(contents).toList();
    singleElements[0] = userID;
    print(userID);
    singleElements[1] = username;
    print(username);
    singleElements[2] = avatar_path;
    print(avatar_path);
    singleElements[3] = country;
    print(country);
    singleElements[4] = sessionID;
    print(sessionID);
    print("DOES THE FILE EXIST? " + '${File('$_localFile').exists()}');
    return singleElements;
  }
  catch (e) {
    print(e.toString());
    return null;
  }
}






addUser() {
  DocumentReference documentReference =
  FirebaseFirestore.instance.collection("users").doc(userID);

  //Map
  Map<String, String> utenti = {"user_id": '${userID}', "username": username, "session_id": sessionID, "avatar_path": avatar_path, "country": country };

  documentReference.set(utenti).whenComplete(() {
    print("$username added to Firestore database");
  });
}

deleteUser(item) {
  DocumentReference documentReference =
  FirebaseFirestore.instance.collection("groups").doc(item);

  documentReference.delete().whenComplete(() {
    print("$item deleted");
  });
}


Future<String> getCurrentUrl() async {

  InAppWebViewController _webViewController;
  current_url = _webViewController.getUrl();
  print(current_url);
  return current_url;

}


Future<String> askForToken() async {
  print('requesting token...');
  final response = await http.get(
      askForToken_url,
    //headers: {HttpHeaders.authorizationHeader: "request_token"},
  );
  final responseJson = json.decode(response.body);
  print("Result: ${response.body}");
  //return Post.fromJson(responseJson);

  token = responseJson['request_token'];
  print("T  O  K  E  N");
  print(token);
  return token;
}



Future authorizeToken() async {
  print('authorizing...');
  final response = await http.get(authorizeToken_url);
  final responseJson = json.decode(response.body);
  print("Result: ${response.body}");
  //return Post.fromJson(responseJson);

  if (responseJson['success'] == true) {
    authorized = true;
  };

}


Future<String> getSessionID() async {
  print('getting session ID...');
  final response = await http.get(
    getSessionID_url,
    //headers: {HttpHeaders.authorizationHeader: "request_token"},
  );
  final responseJson = json.decode(response.body);
  print("Result: ${response.body}");
  //return Post.fromJson(responseJson);

  sessionID = responseJson['session_id'];
  print("S E S S I O N   I D ");
  print(sessionID);
  sessionStarted = true;
  return sessionID;
}

Future<List> getUser() async {
  print('getting user...');
  final response = await http.get(
    getUser_url,
    //headers: {HttpHeaders.authorizationHeader: "request_token"},
  );
  final responseJson = json.decode(response.body);
  print("Result: ${response.body}");
  //return Post.fromJson(responseJson);

  userID = responseJson['id'].toString();
  username = responseJson['username'];
  avatar_path = responseJson['avatar']['tmdb']['avatar_path'];
  country = responseJson['iso_639_1'];
  print("U  S  E  R");
  print(userID);
  print(username);


  return[userID, username, avatar_path, country];
}




class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {


  InAppWebViewController _webViewController;
  String url = " ";
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Log in'),
          elevation: 6,
          centerTitle: true,
          backgroundColor: Color.fromRGBO(13, 37, 63, 1),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color.fromRGBO(1, 180, 228, 1), Color.fromRGBO(144, 206, 161, 1),]
              )
          ),
          child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: RichText(text: TextSpan(children: [
                TextSpan(text: "MatchFlix uses the free and open source database ", style: TextStyle(color: Colors.black)),
                TextSpan(text: "TheMovieDB", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                TextSpan(text: " as its content source and user authentication system.\n\n""Please log into your TheMovieDB account or create a new one:\n", style: TextStyle(color: Colors.black,)),
                TextSpan(text: "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." + url.substring(80) : url}", style: TextStyle(color: Colors.black)),
              ]))

            ),
            Container(
                padding: EdgeInsets.all(0.0),
                child: progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container()),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: InAppWebView(
                  initialUrl: "https://www.themoviedb.org/login",
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        debuggingEnabled: false,
                      )
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    _webViewController = controller;
                  },

                  onLoadStart: (InAppWebViewController controller, String url) {
                    setState(() {
                      this.url = url;
                    });
                  },

                  onLoadStop: (InAppWebViewController controller, String url) async {

                    await readUser();
                    print('H O   T R O V A T O   Q U E S T O   F I L E' + readUser().toString());
                    print(File('$_localFile').exists());
                    if(await File('$_localFile').exists() == false) {

                    if (url.startsWith("https://www.themoviedb.org/u/")) {
                      loggedin = true;
                      
                      await askForToken();
                      print(authorizeToken_url);
                      _webViewController.loadUrl(url: authorizeToken_url);
                      //await authorizeToken();
                      //await getSessionID();
                      //print("Session started B-)");
                    }

                    if (url.contains('authenticate') && url.contains('allow')) {
                      await getSessionID();
                      if (sessionStarted == true) {
                        await getUser();
                        await writeUser(userID, username, avatar_path, country);
                        await addUser();
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) {
                              return new MovieList(sessionID: sessionID,
                                  userID: userID,
                                  username: username,
                                  avatar_path: avatar_path);
                            }
                        ));
                      };
                    }
                    }

                    else {
                      print("S K I P P E D");
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) {
                            return new MovieList(sessionID: sessionID,
                                userID: userID,
                                username: username,
                                avatar_path: avatar_path);
                          }
                      ));
                    };



                    setState(() {
                      this.url = url;

                    });


                  },

                  onProgressChanged: (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },

                ),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[/*
                RaisedButton(
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (_webViewController != null) {
                      _webViewController.goBack();
                    }
                  },
                ),
                RaisedButton(
                  child: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (_webViewController != null) {
                      _webViewController.goForward();
                    }
                  },
                ),
                RaisedButton(
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    if (_webViewController != null) {
                      _webViewController.reload();
                    }
                  },
                ),*/
                RaisedButton(
                  child: Text("Request new token"),
                  onPressed: () async {
                    await askForToken();
                    print(authorizeToken_url);
                    _webViewController.loadUrl(url: authorizeToken_url);
                    if (url.contains('authenticate') && url.contains('allow')) {
                       await getSessionID();
                      if (sessionStarted == true) {
                        await getUser();
                        writeUser(userID, username, avatar_path, country);
                        await addUser();
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) {
                              return new MovieList(sessionID: sessionID,
                                  userID: userID,
                                  username: username,
                                  avatar_path: avatar_path);
                            }
                        ));
                      };
                    };
                  },
                ),
                RaisedButton(
                  child: Text("Skip login"),
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) {
                          return new MovieList(sessionID: sessionID, userID: userID, username: username, avatar_path: avatar_path);
                        }
                    ));
                  },
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
