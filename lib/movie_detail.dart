import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;


import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'movie_list.dart';

var tmdbAPIkey = '197c3e3ad86e0b0c080d2373b01603e0';

var specificMovie;
var specificMovieID = specificMovie['id'];



/*
Future<Map> getSpecificJson() async {
  //var apiKey = getApiKey();

  var url = 'https://api.themoviedb.org/3/movie/'+ specificMovieID + '?api_key=' + tmdbAPIkey;
  var response = await http.get(url);
  return json.decode(response.body);

}



getSpecificData() async {
  var data = await getSpecificJson();


  specificMovieData = data;

}

*/

class MovieItem extends StatefulWidget {
  @override
  MovieItemState createState() {
    return new MovieItemState();
  }

}




class MovieItemState extends State<MovieItem> {

var videoData;



@override
Widget build(BuildContext context) {
  Size screenSize = MediaQuery
      .of(context)
      .size;


}


}


class MovieDetail extends StatefulWidget {
  @override
  _MovieDetailState createState() => _MovieDetailState();
  final specificMovie;
  final currentMovie;
  final videos;

  MovieDetail({Key key, @required this.specificMovie, @required this.currentMovie, @required this.videos}) : super(key: key);

}



class _MovieDetailState extends State<MovieDetail> {

  //MovieDetail(this.specificMovie);


  var image_url = 'https://image.tmdb.org/t/p/w500/';
  var video_url = 'https://www.youtube.com/watch?v=';


  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;


  final List<String> _ids = [
    'nPt8bK2gbaU',
    'gQDByCdjUXw',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ];


@override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videos['results'][0]['key'],
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }








// CREA LE ETICHETTE DEI VARI GENERI IN BASE ALLA VOCE genre_id  DEL FILE JSON

  Widget genere_01(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(9648)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.nights_stay, color: Colors.black38,)
          ),

          label: Text('Mystery'),

        );

      }

      else {
        return Container(
          color: Colors.deepOrangeAccent,
        );
      }
    }
  }



  Widget genere_02(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(80)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.local_police_outlined, color: Colors.black38,)
          ),

          label: Text('Crime'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_03(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(18)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.sentiment_very_dissatisfied_rounded, color: Colors.black38,)
          ),

          label: Text('Drama'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_04(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(28)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.sports_kabaddi, color: Colors.black38,)
          ),

          label: Text('Action'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_05(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(12)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.motorcycle, color: Colors.black38,)
          ),

          label: Text('Adventure'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_06(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(16)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(CupertinoIcons.photo_on_rectangle, color: Colors.black38,)
          ),

          label: Text('Animation'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_07(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(35)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.tag_faces, color: Colors.black38,)
          ),

          label: Text('Comedy'),
        );
      }

      else {
        return Container(

        );
      }
    }
  }



  Widget genere_08(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(99)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.biotech, color: Colors.black38,)
          ),

          label: Text('Documentary'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_09(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(10751)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.family_restroom, color: Colors.black38,)
          ),

          label: Text('Family'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_10(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(14)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.whatshot, color: Colors.black38,)
          ),

          label: Text('Fantasy'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_11(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(36)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.history_edu, color: Colors.black38,)
          ),

          label: Text('History'),
        );
      }

      else {
        return Container();
      }
    }
  }




  Widget genere_12(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(27)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.bug_report, color: Colors.black38,)
          ),

          label: Text('Horror'),
        );
      }

      else {
        return Container();
      }
    }
  }




  Widget genere_13(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(18402)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.music_note, color: Colors.black38,)
          ),

          label: Text('Music'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_14(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(10749)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.favorite, color: Colors.black38,)
          ),

          label: Text('Romance'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_15(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(878)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.science_outlined, color: Colors.black38,)
          ),

          label: Text('Science Fiction'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_16(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(10770)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.live_tv, color: Colors.black38,)
          ),

          label: Text('TV Movie'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_17(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(53)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.bolt, color: Colors.black38,)
          ),

          label: Text('Thriller'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_18(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(10752
      )) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.military_tech, color: Colors.black38,)
          ),

          label: Text('War'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_19(BuildContext context){
    for (int i = 0; i < widget.specificMovie.length; i++) {
      if (widget.currentMovie['genre_ids'].contains(37)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.stars_outlined, color: Colors.black38,)
          ),

          label: Text('Wastern'),
        );
      }

      else {
        return Container();
      }
    }
  }




  void playYoutubeVideo() {
    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "<API_KEY>",
      videoUrl: "https://www.youtube.com/watch?v=wgTBLj7rMPM",
        autoPlay: true,
    );
  }


  @override
  Widget build(BuildContext context) {

  /*getSpecificData();
  print(specificMovieData);*/


    Size screenSize = MediaQuery.of(context).size;
    if (widget.specificMovie != null) {
      return new Scaffold(
        body: new Stack(fit: StackFit.expand, children: [


          new SingleChildScrollView(
            child: new Container(
              margin: const EdgeInsets.all(0.0),
              child: new Column(
                children: <Widget>[
                  new Container(
                    alignment: Alignment.centerLeft,
                    child: new Container(
                      width: screenSize.width,
                      height: screenSize.height * 0.65,
                    ),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(0.0),
                      image: new DecorationImage(
                          image: new NetworkImage(
                              image_url + widget.currentMovie['poster_path']),
                          fit: BoxFit.cover),
                    ),
                  ),
                  new Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 12,
                    ),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[

                        new Text(
                          widget.specificMovie['title'],

                          style: new TextStyle(
                              color: Colors.black38,
                              fontSize: 24.0),
                        ),
                        new Row(children: [

                          Icon(Icons.today_outlined, color: Colors.grey,),


                          Text(
                            widget.specificMovie['release_date'],
                            style: new TextStyle(
                                color: Colors.black38,
                                fontSize: 15.0),
                          ),
                        ]
                        ),

                        new Row(children: [
                          Icon(Icons.rate_review, color: Colors.grey),
                          Text(
                            '${widget.specificMovie['vote_average']}/10',
                            style: new TextStyle(
                                color: Colors.black38,
                                fontSize: 15.0),
                          ),

                        ]
                        ),
                        new Wrap(
                          spacing: 7,

                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          children: [
                            genere_01(context),
                            genere_02(context),
                            genere_03(context),
                            genere_04(context),
                            genere_05(context),
                            genere_06(context),
                            genere_07(context),
                            genere_08(context),
                            genere_09(context),
                            genere_10(context),
                            genere_11(context),
                            genere_12(context),
                            genere_13(context),
                            genere_14(context),
                            genere_15(context),
                            genere_16(context),
                            genere_17(context),
                            genere_18(context),
                            genere_19(context),

                          ]
                      ),
                        Divider()
                      ],
                    ),
                  ),
                  new Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: 7),
                                    child: Text(
                                        widget.specificMovie['tagline'],
                                        textAlign: TextAlign.left,
                                        style: new TextStyle(
                                          color: Colors.black38,
                                          fontSize: 20,
                                        )
                                    )
                                )
                            ),
                            Text(
                                widget.specificMovie['overview'],
                                textAlign: TextAlign.justify,
                                style: new TextStyle(
                                  color: Colors.black38,
                                  fontSize: 17,
                                )
                            ),

                            Container(
                                padding: EdgeInsets.only(top: 10),
                                child: ElevatedButton(

                                    onPressed: null,
                                    child: Text(
                                      'Official Website',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black38),
                                    ),
                                    style: ButtonStyle(

                                      backgroundColor: MaterialStateProperty
                                          .all<Color>(Colors.white),
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        EdgeInsets.all(10.0),),
                                      shape: MaterialStateProperty.all<
                                          StadiumBorder>(StadiumBorder()),
                                      elevation: MaterialStateProperty.all<
                                          double>(1),
                                    )
                                  //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                )
                            ),


                          ]
                      )
                  ),



                  /*new Container(
                    width: screenSize.width,
                    height: screenSize.width * 0.5625,
                    //padding: const EdgeInsets.all(10.0),
                    child: new RaisedButton(
                        child: new Text("Play Default Video"),
                        onPressed: playYoutubeVideo),
                  ),*/



                  new YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    //videoProgressIndicatorColor: Colors.amber,
                    /*progressColors: ProgressColors(
                      playedColor: Colors.amber,
                      handleColor: Colors.amberAccent,
                    ),*/
                 /*   onReady () {
                  _controller.addListener(listener);
                  },*/
                  ),



                  new Padding(padding: const EdgeInsets.all(10.0)),
                  Divider(),
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new ElevatedButton(

                              onPressed: null,
                              child: Text(
                                'Watch Now',
                                style: TextStyle(fontSize: 20,
                                    color: Colors.deepOrangeAccent),
                              ),
                              style: ButtonStyle(

                                backgroundColor: MaterialStateProperty.all<
                                    Color>(Colors.white),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.all(17.0),),
                                shape: MaterialStateProperty.all<StadiumBorder>(
                                    StadiumBorder()),
                                elevation: MaterialStateProperty.all<double>(9),
                              )
                            //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),

                          ElevatedButton(
                              onPressed: null,
                              child: Icon(Icons.save_alt, size: 30,
                                color: Colors.lightBlueAccent,),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                    Color>(Colors.white),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.all(15.0),),
                                shape: MaterialStateProperty.all<CircleBorder>(
                                    CircleBorder()),
                                elevation: MaterialStateProperty.all<double>(9),
                              )
                            //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),

                          ElevatedButton(
                              onPressed: null,
                              child: Icon(
                                Icons.share, size: 30, color: Colors.grey,),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                    Color>(Colors.white),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.all(15.0),),
                                shape: MaterialStateProperty.all<CircleBorder>(
                                    CircleBorder()),
                                elevation: MaterialStateProperty.all<double>(9),
                              )
                            //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),

                        ],
                      )
                  )
                ],
              ),
            ),
          )
        ]),
      );
    }
    else {
      return new Scaffold(
            body: Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator()
      )
      );
    }


  }

}



/*
class MovieDetail extends StatelessWidget {


  final movie;
  var image_url = 'https://image.tmdb.org/t/p/w500/';
  MovieDetail(this.movie);








// CREA LE ETICHETTE DEI VARI GENERI IN BASE ALLA VOCE genre_id  DEL FILE JSON
  Widget genere_01(BuildContext context){
    for (int i = 0; i < movie.length; i++) {
      if (movie['genre_ids'].contains(9648)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.nights_stay, color: Colors.black38,)
          ),

          label: Text('Mystery'),

        );

      }

      else {
        return Container(
          color: Colors.deepOrangeAccent,
        );
      }
    }
  }



  Widget genere_02(BuildContext context){
    for (int i = 0; i < movie.length; i++) {
      if (movie['genre_ids'].contains(80)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.local_police_outlined, color: Colors.black38,)
          ),

          label: Text('Crime'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_03(BuildContext context){
    for (int i = 0; i < movie.length; i++) {
      if (movie['genre_ids'].contains(18)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.sentiment_very_dissatisfied_rounded, color: Colors.black38,)
          ),

          label: Text('Drama'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_04(BuildContext context){
    for (int i = 0; i < movie.length; i++) {
      if (movie['genre_ids'].contains(28)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.sports_kabaddi, color: Colors.black38,)
          ),

          label: Text('Action'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_05(BuildContext context){
    for (int i = 0; i < movie.length; i++) {
      if (movie['genre_ids'].contains(12)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.motorcycle, color: Colors.black38,)
          ),

          label: Text('Adenture'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_06(BuildContext context){
    for (int i = 0; i < movie.length; i++) {
      if (movie['genre_ids'].contains(16)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(CupertinoIcons.photo_on_rectangle, color: Colors.black38,)
          ),

          label: Text('Animation'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_07(BuildContext context){
    for (int i = 0; i < movie.length; i++) {
      if (movie['genre_ids'].contains(35)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.tag_faces, color: Colors.black38,)
          ),

          label: Text('Comedy'),
        );
      }

      else {
        return Container(

        );
      }
    }
  }



  Widget genere_08(BuildContext context){
    for (int i = 0; i < movie.length; i++) {
      if (movie['genre_ids'].contains(99)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.science_outlined, color: Colors.black38,)
          ),

          label: Text('Documentary'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_09(BuildContext context){
    for (int i = 0; i < movie.length; i++) {
      if (movie['genre_ids'].contains(10751)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.family_restroom, color: Colors.black38,)
          ),

          label: Text('Family'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_10(BuildContext context){
    for (int i = 0; i < movie.length; i++) {
      if (movie['genre_ids'].contains(14)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.whatshot, color: Colors.black38,)
          ),

          label: Text('Fantasy'),
        );
      }

      else {
        return Container();
      }
    }
  }



  Widget genere_11(BuildContext context){
    for (int i = 0; i < movie.length; i++) {
      if (movie['genre_ids'].contains(36)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.history_edu, color: Colors.black38,)
          ),

          label: Text('History'),
        );
      }

      else {
        return Container();
      }
    }
  }




  Widget genere_12(BuildContext context){
    for (int i = 0; i < movie.length; i++) {
      if (movie['genre_ids'].contains(27)) {
        return Chip(

          avatar: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.bug_report, color: Colors.black38,)
          ),

          label: Text('Horror'),
        );
      }

      else {
        return Container();
      }
    }
  }








  @override
  Widget build(BuildContext context) {

    print(movie['genre_ids']);



    Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      body: new Stack(fit: StackFit.expand, children: [


        new SingleChildScrollView(
          child: new Container(
            margin: const EdgeInsets.all(0.0),
            child: new Column(
              children: <Widget>[
                new Container(
                  alignment: Alignment.centerLeft,
                  child: new Container(
                    width: screenSize.width,
                    height: screenSize.height * 0.65,
                  ),
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(0.0),
                      image: new DecorationImage(
                          image: new NetworkImage(
                              image_url + movie['poster_path']),
                          fit: BoxFit.cover),
                      ),
                ),
                new Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 12,
                  ),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                            new Text(
                            movie['title'],

                            style: new TextStyle(
                                color: Colors.black38,
                                fontSize: 24.0),
                          ),
                      new Row( children:[

                        Icon(Icons.today_outlined, color: Colors.grey,),


                        Text(
                              movie['release_date'],
                              style: new TextStyle(
                                  color: Colors.black38,
                                  fontSize: 15.0),
                            ),
                      ]
                      ),

                      new Row( children:[
                        Icon(Icons.rate_review, color: Colors.grey),
                        Text(
                        '${movie['vote_average']}/10',
                        style: new TextStyle(
                            color: Colors.black38,
                            fontSize: 15.0),
                          ),

                      ]
                      ),
                      new Wrap(
                              spacing: 7,

                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              children: [
                                  genere_01(context),
                                  genere_02(context),
                                  genere_03(context),
                                  genere_04(context),
                                  genere_05(context),
                                  genere_06(context),
                                  genere_07(context),
                                  genere_08(context),
                                  genere_09(context),
                                  genere_10(context),
                                  genere_11(context),
                                  genere_12(context),
                              ]
                      ),
                      Divider()
                    ],
                  ),
                ),
                new Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                        movie['overview'],
                        style: new TextStyle(
                            color: Colors.black38,
                            fontSize: 17,
                        )
                    )
                    ),
                new Padding(padding: const EdgeInsets.all(10.0)),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                                  new ElevatedButton(

                                    onPressed: null,
                                        child: Text(
                                          movie['release_date'],
                                              style: TextStyle(fontSize: 20, color: Colors.deepOrangeAccent),
                                        ),
                                        style: ButtonStyle(

                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(17.0),),
                                          shape: MaterialStateProperty.all<StadiumBorder>(StadiumBorder()),
                                          elevation: MaterialStateProperty.all<double>(9),
                                        )
                                      //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),

                                  ElevatedButton(
                                      onPressed: null,
                                      child: Icon(Icons.save_alt, size: 30, color: Colors.lightBlueAccent,),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15.0),),
                                        shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                                        elevation: MaterialStateProperty.all<double>(9),
                                      )
                                    //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),

                                  ElevatedButton(
                                      onPressed: null,
                                      child: Icon(Icons.share, size: 30, color: Colors.grey,),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15.0),),
                                        shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
                                        elevation: MaterialStateProperty.all<double>(9),
                                      )
                                    //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),

                        ],
                      )
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
*/