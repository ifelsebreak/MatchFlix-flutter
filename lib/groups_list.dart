import 'package:flutter/material.dart';
import 'package:tmdb_test/auth.dart';
import 'package:tmdb_test/movie_list.dart';
import 'user_details.dart';



Widget newGroup() {
  return Card(
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
  );

}



addGroup() {
  groupsList.insert(groupsList.length-1, newGroup());
}




class GroupsList extends StatefulWidget {

  final groupsList;

  GroupsList({this.groupsList});


  @override
  _GroupsListState createState() => new _GroupsListState();

}




class _GroupsListState extends State<GroupsList> {




  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;
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
                child: Icon(
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
        body: new FutureBuilder<List>(
          future: widget.groupsList,
          builder:
              (BuildContext context, AsyncSnapshot<List> snapshot) {

                  return new ListView.builder(
                      itemCount: groupsList.length,
                      itemBuilder: (context, index) {
                        //final item = groupsList[index];

                        return groupsList[index];

                      }
                  );


          },
        ),

        /*
        new ListView.builder(
          itemCount: groupsList.length,
          itemBuilder: (context, index) {
            final item = groupsList[index];
            return groupsList[index];
        }
        )
        */


    );
  }




}




  List<Widget> groupsList = [
    Card(
        elevation: 5,
        child: InkWell(
            onTap: () {
              // Function is executed on tap.
            },
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child:

                ListTile(
                  title: RichText(text: TextSpan(children: [
                    TextSpan(text: username,
                        style: TextStyle(color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    TextSpan(text: "\nUSER ID: " + '${userID}',
                        style: TextStyle(color: Colors.grey, fontSize: 15)),
                  ])),

                  leading: CircleAvatar(
                    radius: 30.0,
                    backgroundImage:
                    NetworkImage(image_url + avatar_path),
                    backgroundColor: Colors.transparent,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),

                )


            )
        )
    ),


    Card(
        elevation: 5,
        child: InkWell(
            onTap: () {

              groupsList.insert(groupsList.length-1, newGroup());
              Navigator.push(_GroupsListState().context, new MaterialPageRoute(
                  builder: (context) {
                    return new UserDetails();
                  }
              ));


              //print(groupsList);
            },
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text('Create new group', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey)),

                  leading: Icon(Icons.add, size: 60),
                  //trailing: Icon(Icons.arrow_forward_ios),

                )

            )
        )

    ),


  ];

















/*
            children: <Widget>[


              Card(
                elevation: 5,
                child: InkWell(
                    onTap: () {
                      // Function is executed on tap.
                    },
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child:

                      ListTile(
                          title: RichText(text: TextSpan(children: [
                            TextSpan(text: username, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                            TextSpan(text: "\nUSER ID: " + '${userID}', style: TextStyle(color: Colors.grey, fontSize: 15)),
                            ])),

                          leading: CircleAvatar(
                                        radius: 30.0,
                                        backgroundImage:
                                        NetworkImage(image_url + avatar_path),
                                        backgroundColor: Colors.transparent,
                                      ),
                          trailing: Icon(Icons.arrow_forward_ios),

                      )



                  )
                )
              ),




              Card(
                  elevation: 5,
                child: InkWell(
                    onTap: () {
                      // Function is executed on tap.
                    },
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text('Create new group', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),

                        leading: Icon(Icons.add, size: 60),
                        //trailing: Icon(Icons.arrow_forward_ios),

                      )

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
      */