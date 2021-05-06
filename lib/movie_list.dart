import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/physics.dart';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:page_transition/page_transition.dart';
import 'package:speech_bubble/speech_bubble.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'cards/fading_tags.dart';
import 'cards/fading_tags_02.dart';
import 'cards/fading_tags_03.dart';
import 'cards/fading_tags_04.dart';


import 'groups_list.dart';
import 'movie_detail.dart';
import 'auth.dart';
import 'groups_list_add.dart';

//import 'config.dart';



double width;
double height;


var unloadedmovies = [
  {"adult":false,"backdrop_path":"/srYya1ZlI97Au4jUYAktDe3avyA.jpg","genre_ids":[14,28,12],"id":464052,"original_language":"en","original_title":"Wonder Woman 1984","overview":"Loading...","popularity":2635.962,"poster_path":"/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg","release_date":"2020-12-16","title":"Loading...","video":false,"vote_average":7,"vote_count":3339},
  {"adult":false,"backdrop_path":"/srYya1ZlI97Au4jUYAktDe3avyA.jpg","genre_ids":[14,28,12],"id":464052,"original_language":"en","original_title":"Wonder Woman 1984","overview":"Loading...","popularity":2635.962,"poster_path":"/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg","release_date":"2020-12-16","title":"Loading...","video":false,"vote_average":7,"vote_count":3339},
  {"adult":false,"backdrop_path":"/srYya1ZlI97Au4jUYAktDe3avyA.jpg","genre_ids":[14,28,12],"id":464052,"original_language":"en","original_title":"Wonder Woman 1984","overview":"Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s and finds a formidable foe by the name of the Cheetah.","popularity":2635.962,"poster_path":"/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg","release_date":"2020-12-16","title":"Wonder Woman 1984","video":false,"vote_average":7,"vote_count":3339},
  {"adult":false,"backdrop_path":"/srYya1ZlI97Au4jUYAktDe3avyA.jpg","genre_ids":[14,28,12],"id":464052,"original_language":"en","original_title":"Wonder Woman 1984","overview":"Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s and finds a formidable foe by the name of the Cheetah.","popularity":2635.962,"poster_path":"/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg","release_date":"2020-12-16","title":"Wonder Woman 1984","video":false,"vote_average":7,"vote_count":3339},
  {"adult":false,"backdrop_path":"/srYya1ZlI97Au4jUYAktDe3avyA.jpg","genre_ids":[14,28,12],"id":464052,"original_language":"en","original_title":"Wonder Woman 1984","overview":"Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s and finds a formidable foe by the name of the Cheetah.","popularity":2635.962,"poster_path":"/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg","release_date":"2020-12-16","title":"Wonder Woman 1984","video":false,"vote_average":7,"vote_count":3339},
  {"adult":false,"backdrop_path":"/srYya1ZlI97Au4jUYAktDe3avyA.jpg","genre_ids":[14,28,12],"id":464052,"original_language":"en","original_title":"Wonder Woman 1984","overview":"Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s and finds a formidable foe by the name of the Cheetah.","popularity":2635.962,"poster_path":"/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg","release_date":"2020-12-16","title":"Wonder Woman 1984","video":false,"vote_average":7,"vote_count":3339},
];

var currentDraggable = 1;
var current_cover;
var current_id;
var current_tagline;
var current_video;
var current_title;
var specificMovieData;
var currentMovie;
var videoData;


var undoSwipe = false;
var undoCount = 0;

var indice = 0;


var resultsPage = 1;

var image_url = 'https://image.tmdb.org/t/p/w500/';
var tmdbAPIkey = 'PUT YOUR API KEY HERE';

var markFavorite_url = 'https://api.themoviedb.org/3/account/'+ '${userID}' +'/favorite?api_key=' + tmdbAPIkey + '&session_id=' + sessionID;
var addToWatchList_url = 'https://api.themoviedb.org/3/account/' + '${userID}' + '/watchlist?api_key=' + tmdbAPIkey + '&session_id=' + sessionID;














valueLimit(val, min, max) {
  return val < min ? min : (val > max ? max : val);
}

reverseOpacity(value, min, max) {
  return (max + min) - value;
}








Future<http.Response> markFavorite() {
  return http.post(
    markFavorite_url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      "media_type": "movie",
      "media_id": current_id,
      "favorite": true
    }),
  );
}


Future<http.Response> addToWatchList() {
  return http.post(
    addToWatchList_url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      "media_type": "movie",
      "media_id": current_id,
      "watchlist": true
    }),
  );
}







class MovieList extends StatefulWidget {
  final sessionID;
  final userID;
  final username;
  final avatar_path;
  MovieList({Key key, @required this.sessionID, this.userID, this.username, this.avatar_path}) : super(key: key);

  @override
  MovieListState createState() {
    return new MovieListState();
  }

}




class MovieListState extends State<MovieList> with AutomaticKeepAliveClientMixin{

  bool get wantKeepAlive => true;
  var movies;
  var nextMovies;





// CALL JSON FILE
  Future<Map> getJson() async {
    //var apiKey = getApiKey();
    var url = 'https://api.themoviedb.org/3/discover/movie?api_key=' + tmdbAPIkey + '&language=en-US&sort_by=popularity.desc&include_adult=false&page='+ '${resultsPage}';
    var response = await http.get(url);
    return json.decode(response.body);
  }


//GET DATA FROM JSON FILE
  void getData() async {
    var data = await getJson();


    setState(() {

        if (movies?.length == null) {
          movies = data['results'];
        }

    });

  }

  //WITH DATA OBTAINED FROM JSON, CREATE LIST
  Future<List> listaFilm() async {
    if (movies != null) {
      new ListView.builder(
          itemCount: movies == null ? 0 : movies.length,
          itemExtent: 10,
          cacheExtent: 10,

          itemBuilder: (context, i) {
            if (movies != null) {
              return MovieCell(movies, i);
            }
          }
      );
    } else {
      return List();
    }
  }


//CALL NEXT PAGE OF JSON FILE
  Future<Map> getNextJson() async {
    //var apiKey = getApiKey();
    var url = 'https://api.themoviedb.org/3/discover/movie?api_key=' + tmdbAPIkey + '&language=en-US&sort_by=popularity.desc&include_adult=false&page='+ '${resultsPage}';
    var response = await http.get(url);
    return json.decode(response.body);
  }


//GET DATA FROM NEW PAGE OF JSON FILE
  void getNextData() async {


    resultsPage++;
    var nextData = await getNextJson();



    print(nextData['results']);

    setState(() {
      movies.addAll(nextData['results']);
    });
  }









  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    width = screenSize.width;
    height = screenSize.height;


    getData(); 

    if(movies != null) {



    print('indice: $indice');
    print(movies?.length);
    print('currentDraggable: $currentDraggable');
    print('undoSwipe: ${undoSwipe}');
    print(movies[currentDraggable-1]['id']);
    print(current_id);
    print(current_cover);
    print(movies);
    print('session ID: ' + sessionID);
    print('username: ' + username);
    print('userID ' + '${userID}');

    current_id = movies[indice + currentDraggable -1]['id'];
    current_cover = movies[indice + currentDraggable -1]['backdrop_path'];
    current_title = movies[indice + currentDraggable -1]['title'];
    //current_tagline = movies[currentDraggable-1]['tagline'];
    //current_video = movies[currentDraggable-1]['tagline'];
    };


  //if (movies.length == null) {

  //}



if (movies != null) {
  if (indice == movies?.length - 10) {
    getNextData();
  }
}



/*
    final elPescado = <Widget>[];

    for(int i = movies.length-1; i > 0; i--) { //il resto del mazzo
      elPescado.add(
        Positioned(
          left: 5,
          child: MovieCell(movies, i)
        )
      );
    }

    final unPez = <Widget>[MovieCell(movies, 0)]; //carta in cima al mazzo
*/





    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 6,
        centerTitle: true,
        backgroundColor: Colors.white,

        actions:

        <Widget>[
          Padding(
            padding: EdgeInsets.only(right: screenSize.width * 0.27),
            child: IconButton(
              icon: Icon(Icons.movie_filter),
              color: Colors.deepOrangeAccent,
              onPressed: () {
                indice = 0;
              }
              )
          ),
          Padding(
            padding: EdgeInsets.only(right: screenSize.width * 0.27),
            child:  IconButton(
                    icon: Icon(Icons.tune),
                    color: Colors.grey,
                    onPressed: () {
                    null;

                  }
                  )
          ),
          Padding(
            padding: EdgeInsets.only(right: screenSize.width * 0.05),
            child: IconButton(
                    icon: Icon(Icons.group),
                    color: Colors.grey,
                    onPressed: () {
                      /*
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: GroupsList()
                          )
                      );
                      */
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) {
                            return new GroupsListAdd();
                          }
                      ));

                    }
                  )
          ),
        ],
      ),
      body: Container(
          child:Stack(
            children: [

              Align(

                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(

                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              ElevatedButton(  // DISLIKE
                                  onPressed:() {
                                     null;
                                  },
                                  child: Icon(Icons.thumb_down, size: 25, color: Colors.white,),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(17.0),),
                                    shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                                    elevation: MaterialStateProperty.all<double>(4),
                                  )
                                //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),

                              ElevatedButton(  // UNDO

                                  onPressed: () {
                                    undoSwipe = true;
                                  },
                                    //_DraggableCardState._runAnimationRESET;

                                  child: Icon(Icons.replay, size: 20, color: Colors.grey,),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(10.0),),
                                    shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                                    elevation: MaterialStateProperty.all<double>(4),
                                  )
                                //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),

                              ElevatedButton( // SAVE
                                  onPressed: () {addToWatchList();},
                                  child: Icon(Icons.save_alt_outlined, size: 20, color: Colors.lightBlueAccent,),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(10.0),),
                                    shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                                    elevation: MaterialStateProperty.all<double>(4),
                                  )
                                //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),

                              ElevatedButton( // SHOUT
                                  onPressed: () {null;},
                                  child: Icon(Icons.campaign, size: 28, color: Colors.purpleAccent,),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(5.0),),
                                    shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                                    elevation: MaterialStateProperty.all<double>(4),
                                  )
                                //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),

                              ElevatedButton(  // LIKE
                                  onPressed: () {
                                    //markFavorite();
                                    //_DraggableCardState._runAnimationSwipeRight(Offset(0, 30), Size(0,30));
                                    },
                                  child: Icon(Icons.thumb_up, size: 25, color: Colors.white,),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
                                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(17.0),),
                                    shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                                    elevation: MaterialStateProperty.all<double>(4),
                                  )
                                //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              )

                            ],

                  )
                )
              ),


              Container(
                padding: EdgeInsets.only(top: screenSize.height *0.005),
                alignment: Alignment.topCenter,
                child: movies != null ? MovieCell(movies, indice + 5) : Container()
              ),

              DraggableCard5(

                  child: movies != null ? MovieCell(movies, indice + 4) : Container()
              ),

              DraggableCard4(

                  child: movies != null ? MovieCell(movies, indice + 3) : Container()
              ),

              DraggableCard3(

                  child: movies != null ? MovieCell(movies, indice + 2) : Container()
              ),

              DraggableCard2(

                  child: movies != null ? MovieCell(movies, indice + 1) : Container()
              ),

              DraggableCard(

                  child: movies != null ? MovieCell(movies, indice) : Container(
                    alignment: Alignment.center,
                    //padding: EdgeInsets.only(left: screenSize.width/2, top: screenSize.height/ 2),
                      child: CircularProgressIndicator()
                  )
              ),
            ]
    )
    ),




    );
  }
}





class MovieCell extends StatelessWidget {


  final movies;
  final i;
  Color mainColor = const Color(0xff3C3261);



  MovieCell(this.movies, this.i);







  Future<Map> getSpecificJson() async {
    //var apiKey = getApiKey();

    var url = 'https://api.themoviedb.org/3/movie/'+ '${current_id}' + '?api_key=' + '${tmdbAPIkey}';
    print(url);
    var response = await http.get(url);
    return json.decode(response.body);

  }



  getSpecificData() async {
    var data = await getSpecificJson();


    specificMovieData = await data;
    print(specificMovieData);


  }



  Future<Map> getVideoJson() async {
    //var apiKey = getApiKey();
    var url = 'https://api.themoviedb.org/3/movie/' + '${current_id}' + '/videos?api_key=' + '${tmdbAPIkey}' + '&language=en-US';
    print(url);
    var response = await http.get(url);
    return json.decode(response.body);

  }



  getVideoData() async {
    var data = await getVideoJson();

      videoData = data;
      print(videoData);


  }









  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;


    return new Container(

      padding: new EdgeInsets.only(bottom:screenSize.width /60), //distanza delle scritte dal fondo della carta
      width: screenSize.width / 1.03, //larghezza della Card
      height: screenSize.height - screenSize.height * 0.21, //altezza della Card
      decoration: new BoxDecoration(

        image: DecorationImage(
          image: CachedNetworkImageProvider(
            (image_url + movies[i]['poster_path'])
          ),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),

        color: new Color.fromRGBO(255, 255, 255, 1.0),
        borderRadius: new BorderRadius.circular(8.0),
      ),



      child: Container(
        //alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(8.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror,
            colors: <Color>[
              Colors.black.withAlpha(0),
              Colors.black12.withAlpha(10),
              Colors.black45
            ],
          ),
        ),

        child: Stack(
            children:[
              /*Container(

                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(8.0),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                      tileMode: TileMode.clamp,
                    colors: <Color>[
                      Colors.black.withAlpha(0),
                      Colors.black12.withAlpha(10),
                      Colors.black45
                    ],
                  ),
                ),
              ),*/
              Column(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,  //Le scritte stanno in BASSO
                children: <Widget>[

                  InkWell(
                    onTap: () {
                      getSpecificData();
                      getVideoData();
                      print('specificMovieData: ${specificMovieData}');

                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) {
                            return new MovieDetail(specificMovie: specificMovieData, currentMovie: movies[indice + currentDraggable - 1], videos: videoData);
                          }
                      ));
                    },
                          child: ListTile(
                            //leading: Text('Parks & Recreation'),
                            title: Text(
                                movies[i]['title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                )
                            ), //titolo
                            subtitle: Container(
                                child: Text(
                                    movies[i]['overview'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                    style: TextStyle(
                                        color: Colors.white
                                    )
                                )
                            ), //trama
                          ),
                  ),
                ]
              )
      ]),
      ),


    );
  }
}











void _matchModalBottomSheet(context){


  Size screenSize = MediaQuery.of(context).size;

  showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc){
        return Wrap(

          //color: Color.fromARGB(255, 200, 110, 0),
            children: [
              Column(
                  children: [

                    Row(
                        children: [


                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 25),
                            child: Column( children: [
                              Text(
                                  "IT'S A",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontStyle: ui.FontStyle.italic,
                                    fontWeight: ui.FontWeight.bold,
                                    color: Colors.black54,
                                  )
                              ),
                              Text(
                                'MATCH!',
                                style: TextStyle(
                                    fontSize: 75,
                                    fontStyle: ui.FontStyle.italic,
                                    fontWeight: ui.FontWeight.w900,
                                    foreground: Paint()
                                      ..shader = ui.Gradient.linear(
                                        const Offset(0, 20),
                                        const Offset(330, 20),
                                        <Color>[
                                          Colors.purpleAccent,
                                          Colors.lightBlue,
                                        ],
                                      )
                                ),
                              ),

                                        Stack(

                                          alignment: AlignmentDirectional.bottomStart,
                                          children: [

                                          Container(
                                            width: 190.0,
                                            height: 190.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                  fit: BoxFit.cover,
                                                    image: CachedNetworkImageProvider(
                                                        'https://image.tmdb.org/t/p/w500/' + current_cover
                                                    ),
                                                )
                                            )
                                        ),



                                          Positioned(
                                            //top: MediaQuery.of(context).size.height * 0.17,
                                            left: MediaQuery.of(context).size.width * 0.341,
                                            //alignment: AlignmentDirectional.bottomEnd,
                                                child: Container(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    decoration: new BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: new DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: CachedNetworkImageProvider(
                                                              'https://randomuser.me/api/portraits/women/24.jpg' // CO USER 01
                                                          ),
                                                        )
                                                    )
                                                )
                                          ),


                                          Container(
                                              width: 50.0,
                                              height: 50.0,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: CachedNetworkImageProvider(
                                                        ("https://thispersondoesnotexist.com/image") // APP USER
                                                    ),
                                                  )
                                              )
                                          ),


                                  ]
                                  ),

                              Row( children:[


                                    Padding(

                                      padding: EdgeInsets.only(bottom: 3),
                                      child: new SpeechBubble(
                                        nipLocation: NipLocation.RIGHT,
                                        color: Colors.white,
                                        borderRadius: 5,
                                        // child: Column(
                                        //   mainAxisSize: MainAxisSize.min,
                                        //   children: <Widget>[
                                        //     Text("Give your users some guided instruction"),
                                        //     Text("From the inside of a Speech Bubble")
                                        //   ],
                                        // ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[


                                            Text(
                                              "Reply:  ",
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 14.0,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            Icon(Icons.create_outlined, size: 20, color: Colors.black45,)
                                          ],
                                        ),
                                      ),
                                    ),


                                    Padding(

                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.37, top: 3),
                                      child: new SpeechBubble(
                                        nipLocation: NipLocation.TOP_LEFT,
                                        color: Colors.white,
                                        borderRadius: 5,
                                        // child: Column(
                                        //   mainAxisSize: MainAxisSize.min,
                                        //   children: <Widget>[
                                        //     Text("Give your users some guided instruction"),
                                        //     Text("From the inside of a Speech Bubble")
                                        //   ],
                                        // ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[


                                            Text(
                                              "Movie Night? :D",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ),



                              ]),



                            ]),
                          ),

                        ]
                    ),


                    new Wrap(

                      children: <Widget>[
                        new ListTile(
                            //leading: new Icon(Icons.thumb_up),
                            title: new Text(current_title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                              color: Colors.black87,
                              fontSize: 30.0,
                                  fontWeight: FontWeight.bold)
                              ),
                            onTap: () => {}
                        ),
                        new ListTile(
                            leading: new Icon(Icons.live_tv),
                            title: new Text('Watch now or buy for later'),
                            onTap: () => {}
                        ),
                        new ListTile(
                          leading: new Icon(Icons.mark_chat_read_outlined),
                          title: new Text('Chat and schedule a Movie Night'),
                          onTap: () => {},
                        ),
                      ],
                    ),
                  ]
              )
            ]
        );
      }
  );
}











class DraggableCard extends StatefulWidget {
  final Widget child;
  DraggableCard({this.child});

  @override
  _DraggableCardState createState() => _DraggableCardState();
}




class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {



  AnimationController _controller;

  Alignment _dragAlignment = Alignment.topCenter;
  var swipeRightOpacity = 0.0;
  var swipeLeftOpacity = 0.0;
  var swipeDownOpacity = 0.0;
  var swipeUpOpacity = 0.0;


  Alignment get dragAlignment => _dragAlignment;




  Animation<Alignment> _animation;






  void _runAnimationUNDO() {  // ANNULLA LO SWIPE E RIPORTA LA CARTA IN VISTA


    _animation = _controller.drive(
      AlignmentTween(
        begin: Alignment.topCenter,
        end: _dragAlignment,
      ),
    );


    _controller.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.ease);  //
  } // ANNULLA LO SWIPE E RIPORTA LA CARTA IN VISTA







  void _runAnimationRESET() {  // RESETTA LA POSIZIONE DELLA CARTA PER RIPOPOLARE IL MAZZO

    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.topCenter,
      ),
    );


    _controller.animateTo(1.0, duration: const Duration(milliseconds: 0), curve: Curves.linear);  // rendo l'animazione ISTANTANEA per non far notare che la carta torna al centro
  } // TORNA AL CENTRO




  void _runAnimation(Offset pixelsPerSecond, Size size) {  // ANIMAZIONE DI RITORNO QUANDO NON VIENE TRIGGERATO LO SWIPE


    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.topCenter,
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // TORNA AL CENTRO




  void _runAnimationSwipeLeft(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( // ANIMAZIONE DI SWIPE LEFT
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(-width * 1.3, 0),
      ),
    );



    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA A SINISTRA




  void _runAnimationSwipeRight(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(width * 1.3, 0),
      ),
    );



    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA A DESTRA




  void _runAnimationSwipeUp(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( //
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(0, -height / 30),
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA IN ALTO




  void _runAnimationSwipeDown(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( //
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(0, height/30),
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA IN BASSO














  @override
  void initState() {
    super.initState();


    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;

      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final size = MediaQuery.of(context).size;





    if (currentDraggable == 2) {
      if (undoSwipe == true && undoCount == 0) {
        _runAnimationUNDO();
        undoSwipe = false;
        currentDraggable--;
        undoCount = 1;
      }
    }



    if (currentDraggable == 6) { //se le 5 carte sono tutte swipeate le ripopolo con i film successivi e le riporto in vista
      indice = indice +5;
      _runAnimationRESET();
      currentDraggable = 1;
    }



    return Stack(



        children:[



          GestureDetector(




            onPanDown: (details) {
              _controller.stop();
            },
            onPanUpdate: (details) {

              //print(_dragAlignment.x);

              setState(() {

                _dragAlignment += Alignment(

                  details.delta.dx / (size.width / 170), // velocità di trascinamento orizzontale
                  details.delta.dy / (size.height / 17), //velocità di trascinamento verticale

                );

                if (_dragAlignment.y > 0) {
                  swipeDownOpacity = valueLimit((_dragAlignment.y + 1).abs() * 0.2 , 0.0, 1.0);
                  swipeUpOpacity = 0;
                }
                else {
                  swipeUpOpacity = valueLimit((_dragAlignment.y + 1).abs() * 0.2 , 0.0, 1.0);
                  swipeDownOpacity = 0;
                }


                if (_dragAlignment.x > 0) {
                  swipeRightOpacity = valueLimit((_dragAlignment.x).abs() * 0.009, 0.0, 1.0);
                  swipeLeftOpacity = 0;
                }
                else {
                  swipeLeftOpacity = valueLimit((_dragAlignment.x).abs() * 0.009, 0.0, 1.0);
                  swipeRightOpacity = 0;
                }







                /*if (_dragAlignment.y >= -7 && _dragAlignment.y <= 3) {
                      horizontalOpacity = (_dragAlignment.x).abs() * 0.005;
                    }
                    else horizontalOpacity = 0.0;*/

              });
            },
            onPanEnd: (details) {



              if(_dragAlignment.x < -80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) { // SWIPE A SINISTRA

                _runAnimationSwipeLeft(details.velocity.pixelsPerSecond, size);

                currentDraggable++;
                undoCount = 0;

              }

              else if (_dragAlignment.x > 80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) { // SWIPE A DESTRA

                _runAnimationSwipeRight(details.velocity.pixelsPerSecond, size);

                currentDraggable++;
                undoCount = 0;

                markFavorite();


              }

              else if (_dragAlignment.y < -5 && _dragAlignment.x > -80 && _dragAlignment.x < 80) { // SWIPE IN ALTO

                _runAnimationSwipeUp(details.velocity.pixelsPerSecond, size);

                currentDraggable++;
                undoCount = 0;

              }


              else if (_dragAlignment.y > 3 && _dragAlignment.x > -80 && _dragAlignment.x < 80) { // SWIPE IN BASSO

                _runAnimationSwipeDown(details.velocity.pixelsPerSecond, size);

                currentDraggable++;
                undoCount = 0;

                addToWatchList();
              }


              else _runAnimation(details.velocity.pixelsPerSecond, size);

              swipeDownOpacity = 0.0;
              swipeLeftOpacity = 0.0;
              swipeRightOpacity = 0.0;
              swipeUpOpacity = 0.0;





            },


            child:Container(
                    child: Align(
                          alignment: _dragAlignment,
                          child: Transform.rotate(
                            angle: -_dragAlignment.x/300,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                elevation: 0,

                                color: Colors.transparent,
                                child: Stack(
                                    children: [
                                      widget.child,
                                      Opacity(
                                        opacity: swipeRightOpacity,
                                        child: esclamazioni(context),
                                      ),
                                      Opacity(
                                          opacity: swipeUpOpacity,
                                          child: esclamazioni_02(context)
                                      ),
                                      Opacity(
                                        opacity: swipeLeftOpacity,
                                        child: esclamazioni_03(context),
                                      ),
                                      Opacity(
                                          opacity: swipeDownOpacity,
                                          child: esclamazioni_04(context)
                                      )
                                    ]
                                )
                            ),


                          )

            )
            ),
          ),

          /*GestureDetector(


             onPanDown: (details) {
               _controller.stop();
             },
             onPanUpdate: (details) {

               print(_dragAlignment.y);

               setState(() {

                 _dragAlignment += Alignment(

                   details.delta.dx / (size.width / 200), // velocità di trascinamento orizzontale
                   details.delta.dy / (size.height / 20), //velocità di trascinamento verticale

                 );


                 /*if (_dragAlignment.y >= -7 && _dragAlignment.y <= 3) {
                      horizontalOpacity = (_dragAlignment.x).abs() * 0.005;
                    }
                    else horizontalOpacity = 0.0;*/

               });
             },
             onPanEnd: (details) {


               if(_dragAlignment.x < -80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) {

                 _runAnimationSwipeLeft(details.velocity.pixelsPerSecond, size);
               }

               else if (_dragAlignment.x > 80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) {

                 _runAnimationSwipeRight(details.velocity.pixelsPerSecond, size);
               }

               else if (_dragAlignment.y < -5 && _dragAlignment.x > -80 && _dragAlignment.x < 80) {

                 _runAnimationSwipeUp(details.velocity.pixelsPerSecond, size);
               }


               else if (_dragAlignment.y > 3 && _dragAlignment.x > -80 && _dragAlignment.x < 80) {

                 _runAnimationSwipeDown(details.velocity.pixelsPerSecond, size);
               }


               else _runAnimation(details.velocity.pixelsPerSecond, size);

             },


             child:Container(
                 child: Opacity(
                   opacity: (_dragAlignment.x).abs() * 0.006,
                   child: Align(
                       alignment: _dragAlignment,
                       child: Transform.rotate(

                         angle: -_dragAlignment.x/300,
                         child: Card(
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(8.0),
                           ),
                           elevation: 6,

                           color: Colors.transparent,
                           child: widget.child,
                         ),

                       )
                   ),
                 )
             ),

           )*/


          /*GestureDetector(

            onPanDown: (details) {
            _controller.stop();
            },
            onPanUpdate: (details) {




            //print(_dragAlignment);
            setState(() {

            _dragAlignment += Alignment(
            details.delta.dx / (size.width / 20000), // velocità di trascinamento orizzontale
            details.delta.dy / (size.height / 20000), //velocità di trascinamento verticale
            );
            });
            },
            onPanEnd: (details) {
            _runAnimation(details.velocity.pixelsPerSecond, size);
            },


                  child:Container(
                      child: Opacity(
                      opacity: ((_dragAlignment.x).abs() * 0.004),

                        child: Align(
                            alignment: _dragAlignment/18,
                            child: Transform.rotate(

                              angle: -_dragAlignment.x/300,
                              child: esclamazioni(context),


                            )
                        ),

                      )
            )
            )*/  // ESCLAMAZIONI CON EFFETTO FADE IN

        ]
    );

  }

}



















class DraggableCard2 extends StatefulWidget {
  final Widget child;
  DraggableCard2({this.child});

  @override
  _DraggableCard2State createState() => _DraggableCard2State();
}




class _DraggableCard2State extends State<DraggableCard2>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Alignment _dragAlignment = Alignment.topCenter;
  var swipeRightOpacity = 0.0;
  var swipeLeftOpacity = 0.0;
  var swipeDownOpacity = 0.0;
  var swipeUpOpacity = 0.0;


  Alignment get dragAlignment => _dragAlignment;




  Animation<Alignment> _animation;









  void _runAnimationUNDO() {  // ANNULLA LO SWIPE E RIPORTA LA CARTA IN VISTA


    _animation = _controller.drive(
      AlignmentTween(
        begin: Alignment.topCenter,
        end: _dragAlignment,
      ),
    );


    _controller.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.ease);  //
  } // ANNULLA LO SWIPE E RIPORTA LA CARTA IN VISTA








  void _runAnimationRESET() {  // RESETTA LA POSIZIONE DELLA CARTA DOPO LO SWIPE


    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.topCenter,
      ),
    );


    _controller.animateTo(1.0, duration: const Duration(milliseconds: 0), curve: Curves.linear);  // rendo l'animazione ISTANTANEA per non far notare che la carta torna al centro
  } // TORNA AL CENTRO




  void _runAnimation(Offset pixelsPerSecond, Size size) {  // ANIMAZIONE DI RITORNO


    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.topCenter,
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // TORNA AL CENTRO




  void _runAnimationSwipeLeft(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( // ANIMAZIONE DI SWIPE LEFT
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(-width * 1.3, 0),
      ),
    );



    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA A SINISTRA




  void _runAnimationSwipeRight(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(width * 1.3, 0),
      ),
    );



    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA A DESTRA




  void _runAnimationSwipeUp(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( //
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(0, -height/30),
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA IN ALTO




  void _runAnimationSwipeDown(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( //
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(0, height/30),
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA IN BASSO














  @override
  void initState() {
    super.initState();


    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;

      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;
    final size = MediaQuery
        .of(context)
        .size;


    if (currentDraggable == 6) {
      _runAnimationRESET();
    }



    if (currentDraggable == 3) {
      if (undoSwipe == true && undoCount == 0) {
        _runAnimationUNDO();
        undoSwipe = false;
        currentDraggable--;
        undoCount = 1;
      }
    }



    return Stack(
        children:[
          GestureDetector(


            onPanDown: (details) {
              _controller.stop();
            },
            onPanUpdate: (details) {

              //print(_dragAlignment.x);

              setState(() {

                _dragAlignment += Alignment(

                  details.delta.dx / (size.width / 170), // velocità di trascinamento orizzontale
                  details.delta.dy / (size.height / 17), //velocità di trascinamento verticale

                );

                if (_dragAlignment.y > 0) {
                  swipeDownOpacity = valueLimit((_dragAlignment.y + 1).abs() * 0.2 , 0.0, 1.0);
                  swipeUpOpacity = 0;
                }
                else {
                  swipeUpOpacity = valueLimit((_dragAlignment.y + 1).abs() * 0.2 , 0.0, 1.0);
                  swipeDownOpacity = 0;
                }


                if (_dragAlignment.x > 0) {
                  swipeRightOpacity = valueLimit((_dragAlignment.x).abs() * 0.009, 0.0, 1.0);
                  swipeLeftOpacity = 0;
                }
                else {
                  swipeLeftOpacity = valueLimit((_dragAlignment.x).abs() * 0.009, 0.0, 1.0);
                  swipeRightOpacity = 0;
                }




                /*if (_dragAlignment.y >= -7 && _dragAlignment.y <= 3) {
                      horizontalOpacity = (_dragAlignment.x).abs() * 0.005;
                    }
                    else horizontalOpacity = 0.0;*/

              });
            },
            onPanEnd: (details) {


              if(_dragAlignment.x < -80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) { // SWIPE A SINISTRA

                _runAnimationSwipeLeft(details.velocity.pixelsPerSecond, size);
                currentDraggable++;
                undoCount = 0;


              }

              else if (_dragAlignment.x > 80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) { // SWIPE A DESTRA

                _runAnimationSwipeRight(details.velocity.pixelsPerSecond, size);
                currentDraggable++;
                undoCount = 0;

                markFavorite();

              }

              else if (_dragAlignment.y < -5 && _dragAlignment.x > -80 && _dragAlignment.x < 80) { // SWIPE IN ALTO

                _runAnimationSwipeUp(details.velocity.pixelsPerSecond, size);
                currentDraggable++;
                undoCount = 0;

              }


              else if (_dragAlignment.y > 3 && _dragAlignment.x > -80 && _dragAlignment.x < 80) { // SWIPE IN BASSO

                _runAnimationSwipeDown(details.velocity.pixelsPerSecond, size);
                currentDraggable++;
                undoCount = 0;

                addToWatchList();
              }


              else _runAnimation(details.velocity.pixelsPerSecond, size);

              swipeDownOpacity = 0.0;
              swipeLeftOpacity = 0.0;
              swipeRightOpacity = 0.0;
              swipeUpOpacity = 0.0;

            },


            child:Container(
                child: Align(
                    alignment: _dragAlignment,
                    child: Transform.rotate(
                      angle: -_dragAlignment.x/300,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 0,

                          color: Colors.transparent,
                          child: Stack(
                              children: [
                                widget.child,
                                Opacity(
                                  opacity: swipeRightOpacity,
                                  child: esclamazioni(context),
                                ),
                                Opacity(
                                    opacity: swipeUpOpacity,
                                    child: esclamazioni_02(context)
                                ),
                                Opacity(
                                  opacity: swipeLeftOpacity,
                                  child: esclamazioni_03(context),
                                ),
                                Opacity(
                                    opacity: swipeDownOpacity,
                                    child: esclamazioni_04(context)
                                )
                              ]
                          )
                      ),


                    )

                )
            ),
          ),

          /*GestureDetector(


             onPanDown: (details) {
               _controller.stop();
             },
             onPanUpdate: (details) {

               print(_dragAlignment.y);

               setState(() {

                 _dragAlignment += Alignment(

                   details.delta.dx / (size.width / 200), // velocità di trascinamento orizzontale
                   details.delta.dy / (size.height / 20), //velocità di trascinamento verticale

                 );


                 /*if (_dragAlignment.y >= -7 && _dragAlignment.y <= 3) {
                      horizontalOpacity = (_dragAlignment.x).abs() * 0.005;
                    }
                    else horizontalOpacity = 0.0;*/

               });
             },
             onPanEnd: (details) {


               if(_dragAlignment.x < -80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) {

                 _runAnimationSwipeLeft(details.velocity.pixelsPerSecond, size);
               }

               else if (_dragAlignment.x > 80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) {

                 _runAnimationSwipeRight(details.velocity.pixelsPerSecond, size);
               }

               else if (_dragAlignment.y < -5 && _dragAlignment.x > -80 && _dragAlignment.x < 80) {

                 _runAnimationSwipeUp(details.velocity.pixelsPerSecond, size);
               }


               else if (_dragAlignment.y > 3 && _dragAlignment.x > -80 && _dragAlignment.x < 80) {

                 _runAnimationSwipeDown(details.velocity.pixelsPerSecond, size);
               }


               else _runAnimation(details.velocity.pixelsPerSecond, size);

             },


             child:Container(
                 child: Opacity(
                   opacity: (_dragAlignment.x).abs() * 0.006,
                   child: Align(
                       alignment: _dragAlignment,
                       child: Transform.rotate(

                         angle: -_dragAlignment.x/300,
                         child: Card(
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(8.0),
                           ),
                           elevation: 6,

                           color: Colors.transparent,
                           child: widget.child,
                         ),

                       )
                   ),
                 )
             ),

           )*/


          /*GestureDetector(

            onPanDown: (details) {
            _controller.stop();
            },
            onPanUpdate: (details) {




            //print(_dragAlignment);
            setState(() {

            _dragAlignment += Alignment(
            details.delta.dx / (size.width / 20000), // velocità di trascinamento orizzontale
            details.delta.dy / (size.height / 20000), //velocità di trascinamento verticale
            );
            });
            },
            onPanEnd: (details) {
            _runAnimation(details.velocity.pixelsPerSecond, size);
            },


                  child:Container(
                      child: Opacity(
                      opacity: ((_dragAlignment.x).abs() * 0.004),

                        child: Align(
                            alignment: _dragAlignment/18,
                            child: Transform.rotate(

                              angle: -_dragAlignment.x/300,
                              child: esclamazioni(context),


                            )
                        ),

                      )
            )
            )*/  // ESCLAMAZIONI CON EFFETTO FADE IN

        ]
    );

  }

}



















class DraggableCard3 extends StatefulWidget {
  final Widget child;
  DraggableCard3({this.child});

  @override
  _DraggableCard3State createState() => _DraggableCard3State();
}




class _DraggableCard3State extends State<DraggableCard3>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Alignment _dragAlignment = Alignment.topCenter;
  var swipeRightOpacity = 0.0;
  var swipeLeftOpacity = 0.0;
  var swipeDownOpacity = 0.0;
  var swipeUpOpacity = 0.0;


  Alignment get dragAlignment => _dragAlignment;




  Animation<Alignment> _animation;










  void _runAnimationUNDO() {  // ANNULLA LO SWIPE E RIPORTA LA CARTA IN VISTA


    _animation = _controller.drive(
      AlignmentTween(
        begin: Alignment.topCenter,
        end: _dragAlignment,
      ),
    );


    _controller.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.ease);  //
  } // ANNULLA LO SWIPE E RIPORTA LA CARTA IN VISTA








  void _runAnimationRESET() {  // RESETTA LA POSIZIONE DELLA CARTA DOPO LO SWIPE


    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.topCenter,
      ),
    );


    _controller.animateTo(1.0, duration: const Duration(milliseconds: 0), curve: Curves.linear);  // rendo l'animazione ISTANTANEA per non far notare che la carta torna al centro
  } // TORNA AL CENTRO




  void _runAnimation(Offset pixelsPerSecond, Size size) {  // ANIMAZIONE DI RITORNO


    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.topCenter,
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // TORNA AL CENTRO




  void _runAnimationSwipeLeft(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( // ANIMAZIONE DI SWIPE LEFT
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(-width * 1.3, 0),
      ),
    );



    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA A SINISTRA




  void _runAnimationSwipeRight(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(width * 1.3, 0),
      ),
    );



    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA A DESTRA




  void _runAnimationSwipeUp(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( //
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(0, -height/30),
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA IN ALTO




  void _runAnimationSwipeDown(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( //
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(0, height/30),
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA IN BASSO














  @override
  void initState() {
    super.initState();


    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;

      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final size = MediaQuery.of(context).size;



    if (currentDraggable == 6) {

      _runAnimationRESET();

    }



    if (currentDraggable == 4) {
      if (undoSwipe == true && undoCount == 0) {
        _runAnimationUNDO();
        undoSwipe = false;
        currentDraggable--;
        undoCount = 1;
      }
    }



    return Stack(
        children:[
          GestureDetector(


            onPanDown: (details) {
              _controller.stop();
            },
            onPanUpdate: (details) {

              //print(_dragAlignment.x);

              setState(() {

                _dragAlignment += Alignment(

                  details.delta.dx / (size.width / 170), // velocità di trascinamento orizzontale
                  details.delta.dy / (size.height / 17), //velocità di trascinamento verticale

                );

                if (_dragAlignment.y > 0) {
                  swipeDownOpacity = valueLimit((_dragAlignment.y + 1).abs() * 0.2 , 0.0, 1.0);
                  swipeUpOpacity = 0;
                }
                else {
                  swipeUpOpacity = valueLimit((_dragAlignment.y + 1).abs() * 0.2 , 0.0, 1.0);
                  swipeDownOpacity = 0;
                }


                if (_dragAlignment.x > 0) {
                  swipeRightOpacity = valueLimit((_dragAlignment.x).abs() * 0.009, 0.0, 1.0);
                  swipeLeftOpacity = 0;
                }
                else {
                  swipeLeftOpacity = valueLimit((_dragAlignment.x).abs() * 0.009, 0.0, 1.0);
                  swipeRightOpacity = 0;
                }




                /*if (_dragAlignment.y >= -7 && _dragAlignment.y <= 3) {
                      horizontalOpacity = (_dragAlignment.x).abs() * 0.005;
                    }
                    else horizontalOpacity = 0.0;*/

              });
            },
            onPanEnd: (details) {


              if(_dragAlignment.x < -80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) { // SWIPE A SINISTRA

                _runAnimationSwipeLeft(details.velocity.pixelsPerSecond, size);
                currentDraggable++;
                undoCount = 0;

              }

              else if (_dragAlignment.x > 80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) { // SWIPE A DESTRA

                _runAnimationSwipeRight(details.velocity.pixelsPerSecond, size);

                currentDraggable++;
                undoCount = 0;

                markFavorite();

              }

              else if (_dragAlignment.y < -5 && _dragAlignment.x > -80 && _dragAlignment.x < 80) { // SWIPE IN ALTO

                _runAnimationSwipeUp(details.velocity.pixelsPerSecond, size);
                currentDraggable++;
                undoCount = 0;
              }


              else if (_dragAlignment.y > 3 && _dragAlignment.x > -80 && _dragAlignment.x < 80) { // SWIPE IN BASSO

                _runAnimationSwipeDown(details.velocity.pixelsPerSecond, size);

                currentDraggable++;
                undoCount = 0;

                addToWatchList();
              }


              else _runAnimation(details.velocity.pixelsPerSecond, size);

              swipeDownOpacity = 0.0;
              swipeLeftOpacity = 0.0;
              swipeRightOpacity = 0.0;
              swipeUpOpacity = 0.0;

            },


            child:Container(
                child: Align(
                    alignment: _dragAlignment,
                    child: Transform.rotate(
                      angle: -_dragAlignment.x/300,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 0,

                          color: Colors.transparent,
                          child: Stack(
                              children: [
                                widget.child,
                                Opacity(
                                  opacity: swipeRightOpacity,
                                  child: esclamazioni(context),
                                ),
                                Opacity(
                                    opacity: swipeUpOpacity,
                                    child: esclamazioni_02(context)
                                ),
                                Opacity(
                                  opacity: swipeLeftOpacity,
                                  child: esclamazioni_03(context),
                                ),
                                Opacity(
                                    opacity: swipeDownOpacity,
                                    child: esclamazioni_04(context)
                                )
                              ]
                          )
                      ),


                    )

                )
            ),
          ),

          /*GestureDetector(


             onPanDown: (details) {
               _controller.stop();
             },
             onPanUpdate: (details) {

               print(_dragAlignment.y);

               setState(() {

                 _dragAlignment += Alignment(

                   details.delta.dx / (size.width / 200), // velocità di trascinamento orizzontale
                   details.delta.dy / (size.height / 20), //velocità di trascinamento verticale

                 );


                 /*if (_dragAlignment.y >= -7 && _dragAlignment.y <= 3) {
                      horizontalOpacity = (_dragAlignment.x).abs() * 0.005;
                    }
                    else horizontalOpacity = 0.0;*/

               });
             },
             onPanEnd: (details) {


               if(_dragAlignment.x < -80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) {

                 _runAnimationSwipeLeft(details.velocity.pixelsPerSecond, size);
               }

               else if (_dragAlignment.x > 80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) {

                 _runAnimationSwipeRight(details.velocity.pixelsPerSecond, size);
               }

               else if (_dragAlignment.y < -5 && _dragAlignment.x > -80 && _dragAlignment.x < 80) {

                 _runAnimationSwipeUp(details.velocity.pixelsPerSecond, size);
               }


               else if (_dragAlignment.y > 3 && _dragAlignment.x > -80 && _dragAlignment.x < 80) {

                 _runAnimationSwipeDown(details.velocity.pixelsPerSecond, size);
               }


               else _runAnimation(details.velocity.pixelsPerSecond, size);

             },


             child:Container(
                 child: Opacity(
                   opacity: (_dragAlignment.x).abs() * 0.006,
                   child: Align(
                       alignment: _dragAlignment,
                       child: Transform.rotate(

                         angle: -_dragAlignment.x/300,
                         child: Card(
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(8.0),
                           ),
                           elevation: 6,

                           color: Colors.transparent,
                           child: widget.child,
                         ),

                       )
                   ),
                 )
             ),

           )*/


          /*GestureDetector(

            onPanDown: (details) {
            _controller.stop();
            },
            onPanUpdate: (details) {




            //print(_dragAlignment);
            setState(() {

            _dragAlignment += Alignment(
            details.delta.dx / (size.width / 20000), // velocità di trascinamento orizzontale
            details.delta.dy / (size.height / 20000), //velocità di trascinamento verticale
            );
            });
            },
            onPanEnd: (details) {
            _runAnimation(details.velocity.pixelsPerSecond, size);
            },


                  child:Container(
                      child: Opacity(
                      opacity: ((_dragAlignment.x).abs() * 0.004),

                        child: Align(
                            alignment: _dragAlignment/18,
                            child: Transform.rotate(

                              angle: -_dragAlignment.x/300,
                              child: esclamazioni(context),


                            )
                        ),

                      )
            )
            )*/  // ESCLAMAZIONI CON EFFETTO FADE IN

        ]
    );

  }

}




















class DraggableCard4 extends StatefulWidget {
  final Widget child;
  DraggableCard4({this.child});

  @override
  _DraggableCard4State createState() => _DraggableCard4State();
}




class _DraggableCard4State extends State<DraggableCard4>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Alignment _dragAlignment = Alignment.topCenter;
  var swipeRightOpacity = 0.0;
  var swipeLeftOpacity = 0.0;
  var swipeDownOpacity = 0.0;
  var swipeUpOpacity = 0.0;


  Alignment get dragAlignment => _dragAlignment;




  Animation<Alignment> _animation;











  void _runAnimationUNDO() {  // ANNULLA LO SWIPE E RIPORTA LA CARTA IN VISTA


    _animation = _controller.drive(
      AlignmentTween(
        begin: Alignment.topCenter,
        end: _dragAlignment,
      ),
    );


    _controller.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.ease);  //
  } // ANNULLA LO SWIPE E RIPORTA LA CARTA IN VISTA












  void _runAnimationRESET() {  // RESETTA LA POSIZIONE DELLA CARTA DOPO LO SWIPE


    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.topCenter,
      ),
    );


    _controller.animateTo(1.0, duration: const Duration(milliseconds: 0), curve: Curves.linear);  // rendo l'animazione ISTANTANEA per non far notare che la carta torna al centro
  } // TORNA AL CENTRO




  void _runAnimation(Offset pixelsPerSecond, Size size) {  // ANIMAZIONE DI RITORNO


    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.topCenter,
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // TORNA AL CENTRO




  void _runAnimationSwipeLeft(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( // ANIMAZIONE DI SWIPE LEFT
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(-width * 1.3, 0),
      ),
    );



    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA A SINISTRA




  void _runAnimationSwipeRight(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(width * 1.3, 0),
      ),
    );



    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA A DESTRA




  void _runAnimationSwipeUp(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( //
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(0, -height/30),
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA IN ALTO




  void _runAnimationSwipeDown(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( //
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(0, height/30),
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA IN BASSO














  @override
  void initState() {
    super.initState();


    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;

      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final size = MediaQuery.of(context).size;


    if (currentDraggable == 6) {

      _runAnimationRESET();

    }






    if (currentDraggable == 5) {
      if (undoSwipe == true && undoCount == 0) {
        _runAnimationUNDO();
        undoSwipe = false;
        currentDraggable--;
        undoCount = 1;
      }
    }





    return Stack(
        children:[
          GestureDetector(


            onPanDown: (details) {
              _controller.stop();
            },
            onPanUpdate: (details) {

              //print(_dragAlignment.x);

              setState(() {

                _dragAlignment += Alignment(

                  details.delta.dx / (size.width / 170), // velocità di trascinamento orizzontale
                  details.delta.dy / (size.height / 17), //velocità di trascinamento verticale

                );

                if (_dragAlignment.y > 0) {
                  swipeDownOpacity = valueLimit((_dragAlignment.y + 1).abs() * 0.2 , 0.0, 1.0);
                  swipeUpOpacity = 0;
                }
                else {
                  swipeUpOpacity = valueLimit((_dragAlignment.y + 1).abs() * 0.2 , 0.0, 1.0);
                  swipeDownOpacity = 0;
                }


                if (_dragAlignment.x > 0) {
                  swipeRightOpacity = valueLimit((_dragAlignment.x).abs() * 0.009, 0.0, 1.0);
                  swipeLeftOpacity = 0;
                }
                else {
                  swipeLeftOpacity = valueLimit((_dragAlignment.x).abs() * 0.009, 0.0, 1.0);
                  swipeRightOpacity = 0;
                }




                /*if (_dragAlignment.y >= -7 && _dragAlignment.y <= 3) {
                      horizontalOpacity = (_dragAlignment.x).abs() * 0.005;
                    }
                    else horizontalOpacity = 0.0;*/

              });
            },
            onPanEnd: (details) {


              if(_dragAlignment.x < -80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) { // SWIPE A SINISTRA

                _runAnimationSwipeLeft(details.velocity.pixelsPerSecond, size);
                currentDraggable++;
                undoCount = 0;

              }

              else if (_dragAlignment.x > 80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) { // SWIPE A DESTRA

                _runAnimationSwipeRight(details.velocity.pixelsPerSecond, size);

                currentDraggable++;
                undoCount = 0;

                markFavorite();

                //if (FireBase.User01.likedList.contains(specificMovie['id']) == true ) {
                _matchModalBottomSheet(context);

                //}



              }

              else if (_dragAlignment.y < -5 && _dragAlignment.x > -80 && _dragAlignment.x < 80) { // SWIPE IN ALTO

                _runAnimationSwipeUp(details.velocity.pixelsPerSecond, size);

                currentDraggable++;

                undoCount = 0;
              }


              else if (_dragAlignment.y > 3 && _dragAlignment.x > -80 && _dragAlignment.x < 80) { // SWIPE IN BASSO

                _runAnimationSwipeDown(details.velocity.pixelsPerSecond, size);
                currentDraggable++;

                undoCount = 0;

                addToWatchList();
              }


              else _runAnimation(details.velocity.pixelsPerSecond, size);

              swipeDownOpacity = 0.0;
              swipeLeftOpacity = 0.0;
              swipeRightOpacity = 0.0;
              swipeUpOpacity = 0.0;

            },


            child:Container(
                child: Align(
                    alignment: _dragAlignment,
                    child: Transform.rotate(
                      angle: -_dragAlignment.x/300,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 0,

                          color: Colors.transparent,
                          child: Stack(
                              children: [
                                widget.child,
                                Opacity(
                                  opacity: swipeRightOpacity,
                                  child: esclamazioni(context),
                                ),
                                Opacity(
                                    opacity: swipeUpOpacity,
                                    child: esclamazioni_02(context)
                                ),
                                Opacity(
                                  opacity: swipeLeftOpacity,
                                  child: esclamazioni_03(context),
                                ),
                                Opacity(
                                    opacity: swipeDownOpacity,
                                    child: esclamazioni_04(context)
                                )
                              ]
                          )
                      ),


                    )

                )
            ),
          ),

          /*GestureDetector(


             onPanDown: (details) {
               _controller.stop();
             },
             onPanUpdate: (details) {

               print(_dragAlignment.y);

               setState(() {

                 _dragAlignment += Alignment(

                   details.delta.dx / (size.width / 200), // velocità di trascinamento orizzontale
                   details.delta.dy / (size.height / 20), //velocità di trascinamento verticale

                 );


                 /*if (_dragAlignment.y >= -7 && _dragAlignment.y <= 3) {
                      horizontalOpacity = (_dragAlignment.x).abs() * 0.005;
                    }
                    else horizontalOpacity = 0.0;*/

               });
             },
             onPanEnd: (details) {


               if(_dragAlignment.x < -80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) {

                 _runAnimationSwipeLeft(details.velocity.pixelsPerSecond, size);
               }

               else if (_dragAlignment.x > 80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) {

                 _runAnimationSwipeRight(details.velocity.pixelsPerSecond, size);
               }

               else if (_dragAlignment.y < -5 && _dragAlignment.x > -80 && _dragAlignment.x < 80) {

                 _runAnimationSwipeUp(details.velocity.pixelsPerSecond, size);
               }


               else if (_dragAlignment.y > 3 && _dragAlignment.x > -80 && _dragAlignment.x < 80) {

                 _runAnimationSwipeDown(details.velocity.pixelsPerSecond, size);
               }


               else _runAnimation(details.velocity.pixelsPerSecond, size);

             },


             child:Container(
                 child: Opacity(
                   opacity: (_dragAlignment.x).abs() * 0.006,
                   child: Align(
                       alignment: _dragAlignment,
                       child: Transform.rotate(

                         angle: -_dragAlignment.x/300,
                         child: Card(
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(8.0),
                           ),
                           elevation: 6,

                           color: Colors.transparent,
                           child: widget.child,
                         ),

                       )
                   ),
                 )
             ),

           )*/


          /*GestureDetector(

            onPanDown: (details) {
            _controller.stop();
            },
            onPanUpdate: (details) {




            //print(_dragAlignment);
            setState(() {

            _dragAlignment += Alignment(
            details.delta.dx / (size.width / 20000), // velocità di trascinamento orizzontale
            details.delta.dy / (size.height / 20000), //velocità di trascinamento verticale
            );
            });
            },
            onPanEnd: (details) {
            _runAnimation(details.velocity.pixelsPerSecond, size);
            },


                  child:Container(
                      child: Opacity(
                      opacity: ((_dragAlignment.x).abs() * 0.004),

                        child: Align(
                            alignment: _dragAlignment/18,
                            child: Transform.rotate(

                              angle: -_dragAlignment.x/300,
                              child: esclamazioni(context),


                            )
                        ),

                      )
            )
            )*/  // ESCLAMAZIONI CON EFFETTO FADE IN

        ]
    );

  }

}




















class DraggableCard5 extends StatefulWidget {
  final Widget child;
  DraggableCard5({this.child});

  @override
  _DraggableCard5State createState() => _DraggableCard5State();
}




class _DraggableCard5State extends State<DraggableCard5>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Alignment _dragAlignment = Alignment.topCenter;
  var swipeRightOpacity = 0.0;
  var swipeLeftOpacity = 0.0;
  var swipeDownOpacity = 0.0;
  var swipeUpOpacity = 0.0;


  Alignment get dragAlignment => _dragAlignment;




  Animation<Alignment> _animation;










  void _runAnimationUNDO() {  // ANNULLA LO SWIPE E RIPORTA LA CARTA IN VISTA


    _animation = _controller.drive(
      AlignmentTween(
        begin: Alignment.topCenter,
        end: _dragAlignment,
      ),
    );


    _controller.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.ease);  //
  } // ANNULLA LO SWIPE E RIPORTA LA CARTA IN VISTA











  void _runAnimationRESET() {  // RESETTA LA POSIZIONE DELLA CARTA DOPO LO SWIPE


    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.topCenter,
      ),
    );


    _controller.animateTo(1.0, duration: const Duration(milliseconds: 0), curve: Curves.linear);  // rendo l'animazione ISTANTANEA per non far notare che la carta torna al centro
  } // TORNA AL CENTRO




  void _runAnimation(Offset pixelsPerSecond, Size size) {  // ANIMAZIONE DI RITORNO


    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.topCenter,
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // TORNA AL CENTRO




  void _runAnimationSwipeLeft(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( // ANIMAZIONE DI SWIPE LEFT
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(-width * 1.3, 0),
      ),
    );



    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA A SINISTRA




  void _runAnimationSwipeRight(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(width * 1.3, 0),
      ),
    );



    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA A DESTRA




  void _runAnimationSwipeUp(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( //
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(0, -height/30),
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA IN ALTO




  void _runAnimationSwipeDown(Offset pixelsPerSecond, Size size) {


    _animation = _controller.drive( //
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(0, height/30),
      ),
    );






    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  } // VA IN BASSO














  @override
  void initState() {
    super.initState();


    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;

      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final size = MediaQuery.of(context).size;



    if (currentDraggable == 6) {

      _runAnimationRESET();

    }







    if (currentDraggable == 6) {
      if (undoSwipe == true && undoCount == 0) {
        _runAnimationUNDO();
        undoSwipe = false;
        currentDraggable--;
        undoCount = 1;
      }
    }







    return Stack(
        children:[
          GestureDetector(


            onPanDown: (details) {
              _controller.stop();
            },
            onPanUpdate: (details) {

              //print(_dragAlignment.x);

              setState(() {

                _dragAlignment += Alignment(

                  details.delta.dx / (size.width / 170), // velocità di trascinamento orizzontale
                  details.delta.dy / (size.height / 17), //velocità di trascinamento verticale

                );

                if (_dragAlignment.y > 0) {
                  swipeDownOpacity = valueLimit((_dragAlignment.y + 1).abs() * 0.2 , 0.0, 1.0);
                  swipeUpOpacity = 0;
                }
                else {
                  swipeUpOpacity = valueLimit((_dragAlignment.y + 1).abs() * 0.2 , 0.0, 1.0);
                  swipeDownOpacity = 0;
                }


                if (_dragAlignment.x > 0) {
                  swipeRightOpacity = valueLimit((_dragAlignment.x).abs() * 0.009, 0.0, 1.0);
                  swipeLeftOpacity = 0;
                }
                else {
                  swipeLeftOpacity = valueLimit((_dragAlignment.x).abs() * 0.009, 0.0, 1.0);
                  swipeRightOpacity = 0;
                }




                /*if (_dragAlignment.y >= -7 && _dragAlignment.y <= 3) {
                      horizontalOpacity = (_dragAlignment.x).abs() * 0.005;
                    }
                    else horizontalOpacity = 0.0;*/

              });
            },
            onPanEnd: (details) {


              if(_dragAlignment.x < -80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) { // SWIPE A SINISTRA

                _runAnimationSwipeLeft(details.velocity.pixelsPerSecond, size);

                currentDraggable++;
                undoCount = 0;

              }

              else if (_dragAlignment.x > 80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) { // SWIPE A DESTRA

                _runAnimationSwipeRight(details.velocity.pixelsPerSecond, size);

                currentDraggable++;
                undoCount = 0;

                markFavorite();

              }

              else if (_dragAlignment.y < -5 && _dragAlignment.x > -80 && _dragAlignment.x < 80) { // SWIPE IN ALTO

                _runAnimationSwipeUp(details.velocity.pixelsPerSecond, size);

                currentDraggable++;
                undoCount = 0;
              }


              else if (_dragAlignment.y > 3 && _dragAlignment.x > -80 && _dragAlignment.x < 80) { // SWIPE IN BASSO

                _runAnimationSwipeDown(details.velocity.pixelsPerSecond, size);

                currentDraggable++;
                undoCount = 0;
                addToWatchList();

              }


              else _runAnimation(details.velocity.pixelsPerSecond, size);

              swipeDownOpacity = 0.0;
              swipeLeftOpacity = 0.0;
              swipeRightOpacity = 0.0;
              swipeUpOpacity = 0.0;

            },


            child:Container(
                child: Align(
                    alignment: _dragAlignment,
                    child: Transform.rotate(
                      angle: -_dragAlignment.x/300,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 0,

                          color: Colors.transparent,
                          child: Stack(
                              children: [
                                widget.child,
                                Opacity(
                                  opacity: swipeRightOpacity,
                                  child: esclamazioni(context),
                                ),
                                Opacity(
                                    opacity: swipeUpOpacity,
                                    child: esclamazioni_02(context)
                                ),
                                Opacity(
                                  opacity: swipeLeftOpacity,
                                  child: esclamazioni_03(context),
                                ),
                                Opacity(
                                    opacity: swipeDownOpacity,
                                    child: esclamazioni_04(context)
                                )
                              ]
                          )
                      ),


                    )

                )
            ),
          ),

          /*GestureDetector(


             onPanDown: (details) {
               _controller.stop();
             },
             onPanUpdate: (details) {

               print(_dragAlignment.y);

               setState(() {

                 _dragAlignment += Alignment(

                   details.delta.dx / (size.width / 200), // velocità di trascinamento orizzontale
                   details.delta.dy / (size.height / 20), //velocità di trascinamento verticale

                 );


                 /*if (_dragAlignment.y >= -7 && _dragAlignment.y <= 3) {
                      horizontalOpacity = (_dragAlignment.x).abs() * 0.005;
                    }
                    else horizontalOpacity = 0.0;*/

               });
             },
             onPanEnd: (details) {


               if(_dragAlignment.x < -80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) {

                 _runAnimationSwipeLeft(details.velocity.pixelsPerSecond, size);
               }

               else if (_dragAlignment.x > 80 && _dragAlignment.y > -5 && _dragAlignment.y < 4) {

                 _runAnimationSwipeRight(details.velocity.pixelsPerSecond, size);
               }

               else if (_dragAlignment.y < -5 && _dragAlignment.x > -80 && _dragAlignment.x < 80) {

                 _runAnimationSwipeUp(details.velocity.pixelsPerSecond, size);
               }


               else if (_dragAlignment.y > 3 && _dragAlignment.x > -80 && _dragAlignment.x < 80) {

                 _runAnimationSwipeDown(details.velocity.pixelsPerSecond, size);
               }


               else _runAnimation(details.velocity.pixelsPerSecond, size);

             },


             child:Container(
                 child: Opacity(
                   opacity: (_dragAlignment.x).abs() * 0.006,
                   child: Align(
                       alignment: _dragAlignment,
                       child: Transform.rotate(

                         angle: -_dragAlignment.x/300,
                         child: Card(
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(8.0),
                           ),
                           elevation: 6,

                           color: Colors.transparent,
                           child: widget.child,
                         ),

                       )
                   ),
                 )
             ),

           )*/


          /*GestureDetector(

            onPanDown: (details) {
            _controller.stop();
            },
            onPanUpdate: (details) {




            //print(_dragAlignment);
            setState(() {

            _dragAlignment += Alignment(
            details.delta.dx / (size.width / 20000), // velocità di trascinamento orizzontale
            details.delta.dy / (size.height / 20000), //velocità di trascinamento verticale
            );
            });
            },
            onPanEnd: (details) {
            _runAnimation(details.velocity.pixelsPerSecond, size);
            },


                  child:Container(
                      child: Opacity(
                      opacity: ((_dragAlignment.x).abs() * 0.004),

                        child: Align(
                            alignment: _dragAlignment/18,
                            child: Transform.rotate(

                              angle: -_dragAlignment.x/300,
                              child: esclamazioni(context),


                            )
                        ),

                      )
            )
            )*/  // ESCLAMAZIONI CON EFFETTO FADE IN

        ]
    );

  }

}

