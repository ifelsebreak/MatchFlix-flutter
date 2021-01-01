import 'package:flutter/material.dart';


Scaffold lista_gruppi(
    BuildContext context) {

  Size screenSize = MediaQuery.of(context).size;
  // print("Card");
  return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 6,
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: screenSize.width * 0.3),
              child: IconButton(
                  icon: Icon(Icons.movie_filter),
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.pop(context);
                  }
              )
          ),
          Padding(
              padding: EdgeInsets.only(right: screenSize.width * 0.3),
              child:  Icon(
                Icons.tune,
                color: Colors.grey,
              )
          ),
          Padding(
              padding: EdgeInsets.only(right: screenSize.width * 0.05),
              child: IconButton(
                  icon: Icon(Icons.group),
                  color: Colors.deepOrangeAccent,
                  onPressed: () {
                    null;
                  }
              )
          ),
        ],
      ),
      body: Column(



            children: const <Widget>[


              Card(
                elevation: 5,
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child:

                      ListTile(
                          title: Text('Your profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),

                          leading: CircleAvatar(
                                        radius: 30.0,
                                        backgroundImage:
                                        NetworkImage("https://thispersondoesnotexist.com/image"),
                                        backgroundColor: Colors.transparent,
                                      ),
                          trailing: Icon(Icons.arrow_forward_ios),

                      )



                  )

              ),





              Card(
                  elevation: 5,
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text('Group 1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),

                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                          NetworkImage("https://randomuser.me/api/portraits/women/24.jpg"),
                          backgroundColor: Colors.transparent,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),

                      )

                  )

              ),









            ],



      )
  );




}