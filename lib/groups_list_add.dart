import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

import 'package:flutter/cupertino.dart';

import 'package:tmdb_test/movie_list.dart';
import 'auth.dart';

var uuid = Uuid();

var inviteSender;




class GroupsListAdd extends StatefulWidget {
  @override
  _GroupsListAddState createState() => _GroupsListAddState();

}

class _GroupsListAddState extends State<GroupsListAdd> {


  String groupname = "";
  String groupID = "";
  String memberID = "";
  String memberID_01 = "";
  String memberID_02 = "";
  String memberID_03 = "";
  String memberID_04 = "";

  String creatorID = "";
  String creatorname = "";
  String creator_avatar = "";


  Future<bool> matchingGroups(String id) async {


    final result = await FirebaseFirestore.instance.collection('users/${userID}/groups').doc(id).get();


    return result.exists;
  }



  sendRequest(groupID) async {
    CollectionReference whatTheOtherSees = //i CREATE A TEMPORARY ITEM IN THE OTHER USER'S PROFILE, WHICH CAN BE ACCEPTED OR REJECTED BY THE USER
    FirebaseFirestore.instance.collection("users/${memberID_01}/incoming_requests");
    whatTheOtherSees.get;
    print("SENDING INVITE:  " + whatTheOtherSees.toString());

    Map<String, dynamic> invite = {"approved": "pending", "group_id": groupID, "groupname": groupname, "creator_id":userID, "creator_name": username, "avatar_path": avatar_path};

    whatTheOtherSees.doc(groupID).set(invite).whenComplete(() {
      print("$groupname INVITE SENT");
    });

    CollectionReference whatISeeForNow = //I CREATE A TEMPORARY ITEM HERE IN MY PROFILE WHILE MY REQUEST IS PENDING
    FirebaseFirestore.instance.collection("users/${userID}/sent_requests");
    whatISeeForNow.get;

    whatISeeForNow.doc(groupID).set(invite).whenComplete(() {
      print("$groupname :LET'S SEE IF GETS ACCEPTED");
    });

    }


  Future checkRequest() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("users/${userID}/incoming_requests").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      inviteSender = querySnapshot.docs[i].get("creator_name");
      var approved = querySnapshot.docs[i].get("approved");
      print("SENDER: " + inviteSender);
      print("A P P R O V E D :   ${approved}");
    }
  }


  Future checkLiked() async {
    // var matching_members = 0;
    // my_groups = users/userID/groups.get().toList();
    //for (i=0; i < my_groups.length; i++) {
    //    members = groups/my_groups[i][id]/members.get().toList();
    //    for (u=0; u < members.lenght; u++) {
    //        liked = users/members[u][user_id]/liked.get().tolist();
    //          for (j=0; j < liked.length; j++){
    //               if ( liked[j]['movie_id'] == movies[indice + currentDraggable -1]['id']) {
    //                    matching_members++;
    //               }
    //               if (u = members.legnth - 1 || matching_members == members.length) {
    //                   _matchModalBottomSheet(context, my_groups[i], members);
    //               }
    //          }
    //    }
    // }
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("users/${userID}/liked").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].get("id") == null);
    }
  }



  acceptRequest(groupID, groupname, creatorID, creatorname, creator_avatar) async {
    DocumentReference globalGroupReference =
    FirebaseFirestore.instance.collection("groups").doc(groupID); //I CREATE THE GLOBAL-LEVEL GROUP


    Map<String, dynamic> group = {
      "group_id": groupID,
      "groupname": groupname,
      "creator_id":creatorID,
      "creator_name": creatorname,
      "avatar_path": creator_avatar
    };

    globalGroupReference.set(group).whenComplete(() {
      print("GLOBAL $groupname group created");
    });



    DocumentReference myGroupReference =
    FirebaseFirestore.instance.collection("users").doc(
        '${userID}/groups/' + groupID); // I CREATE THE USER-LEVEL GROUP FOR MY PROFILE


    Map<String, String> myGroup = { "group_id": groupID};
/*
    Map<String, String> myGroup = {
      "group_id": groupID,
      "groupname": groupname,
      "creator_id": creatorID,
      "creator_name": creatorname,
      "creator_avatar": creator_avatar
    };*/

    myGroupReference.set(myGroup).whenComplete(() {
      print("My $groupname group created");
    });


    DocumentReference hisGroupReference =
    FirebaseFirestore.instance.collection("users").doc(
        '${creatorID}/groups/' + groupID); // I CREATE THE USER-LEVEL GROUP FOR THE OTHER USER'S PROFILE

    Map<String, String> hisGroup = { "group_id": groupID};

/*
    Map<String, String> hisGroup = {
      "group_id": groupID,
      "groupname": groupname,
      "creator_id": creatorID,
      "creator_name": creatorname,
      "creator_avatar": creator_avatar
    };*/

    hisGroupReference.set(hisGroup).whenComplete(() {
      print("His $groupname group created");
    });
  }

deleteAcceptedRequest(groupID) async {

    DocumentReference myRequestReference =
    FirebaseFirestore.instance.collection("users").doc('${userID}/incoming_request/'+ groupID); // I DELETE MY INCOMING REQUEST
    print('Trying to delete users/${userID}/incoming_requests/${groupID}/');
    await myRequestReference.delete().whenComplete(() => print('deleted'));


    CollectionReference hisRequestReference =
    FirebaseFirestore.instance.collection('users/${creatorID}/sent_request'); // I DELETE HIS OUTGOING REQUEST
    print('Trying to delete users/${creatorID}/incoming_requests/${groupID}/');
    await hisRequestReference.doc(groupID).delete().whenComplete(() => print('deleted'));

  }


 /*createGroup() {
    DocumentReference globalGroupReference =
    Firestore.instance.collection("groups").document(groupID);

    //Map
    Map<String, dynamic> group = {"approved": "pending", "group_id": groupID, "groupname": groupname, "creator_id":userID, "creator_name": username, "avatar_path": avatar_path};

    globalGroupReference.setData(group).whenComplete(() {
      print("GLOBAL $groupname group created");
    });
  }*/

  deleteGroup(item) {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("users").doc('${userID}/groups/'+ groupname);

    documentReference.delete().whenComplete(() {
      print("$item deleted");
    });
  }




  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(
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

      body: Column(
        children: [

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


              StreamBuilder( // ACCEPTED REQUESTS, CREATED GROUPS

                  stream: FirebaseFirestore.instance.collection("groups").snapshots(),
                  builder: (context, snapshots) {
                    if (snapshots.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshots.data.documents.length,
                          itemBuilder: (context, index) {
                            FirebaseFirestore firestoreDatabase= FirebaseFirestore.instance;

                            DocumentSnapshot documentSnapshot =
                            snapshots.data.documents[index];
                            /*if (documentSnapshot['group_id'] == FirebaseFirestore.instance.collection("users").doc('${userID}/groups/') ) {
                              print ("I FOUND THE MATCHING GROUP ${documentSnapshot['groupname']}");*/
                            return FutureBuilder<bool>(
                              future: matchingGroups(

                                snapshots.data.documents[index]['group_id'].toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                  if (snapshot.data) {
                            return Dismissible(
                                onDismissed: (direction) {
                                  deleteGroup(documentSnapshot["groupname"]);
                                },
                                key: Key(documentSnapshot["groupname"]),
                                child: Card(
                                  elevation: 5,
                                  margin: EdgeInsets.all(5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Column( children: [
                                        ListTile(
                                          contentPadding: EdgeInsets.only(left: 50),
                                          title: RichText(text: TextSpan(children: [
                                            TextSpan(text: documentSnapshot["groupname"],
                                                    style: TextStyle(color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                            TextSpan(text: "\nCreated by: " + '${documentSnapshot["creator_name"]}',
                                                    style: TextStyle(color: Colors.grey, fontSize: 15)),
                                          ])),//Text(documentSnapshot["groupname"]),
                                          leading: Stack(
                                              children: [
                                              Positioned( left: 10,
                                                  child: CircleAvatar(
                                                    radius: 15.0,
                                                    backgroundImage:
                                                    NetworkImage(image_url + avatar_path),
                                                    backgroundColor: Colors.transparent,
                                                  )
                                              ),
                                              Positioned(
                                                  child: CircleAvatar(
                                                    radius: 15.0,
                                                    backgroundImage:
                                                    NetworkImage(image_url + documentSnapshot["avatar_path"]),
                                                    backgroundColor: Colors.transparent,
                                                )
                                                ),



                                          ]
                                          ),

                                            trailing: Icon(Icons.arrow_forward_ios),
                                        /*trailing:
                                          IconButton(



                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                deleteTodos(documentSnapshot["groupname"]);
                                              }),
                                          */
                                      ),


                                  ]),
                                ));

    }
    }
                                  return Container();
    }
    );

                           /* } else {
                              print('I did not find matching groups ids');
                              print(firestoreDatabase.collection("users/${userID}/groups/").get().toString());
                            }*/
                          });
                    } else { print("I   F O U N D   T H E S E   G R O U P S :" + FirebaseFirestore.instance.collection("users").doc('${userID}/groups/').snapshots().toString());
                      return Align(

                        alignment: FractionalOffset.bottomCenter,
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),



          StreamBuilder( // INCOMING INVITES PENDING
              stream: FirebaseFirestore.instance.collection("users/${userID}/incoming_requests/").snapshots(),
              builder: (context, snapshots) {
                if (snapshots.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshots.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                        snapshots.data.documents[index];
                        return Dismissible(
                            onDismissed: (direction) {
                              deleteGroup(documentSnapshot["groupname"]);
                            },
                            key: Key(documentSnapshot["groupname"]),
                            child: InkWell(
                              onTap: null,
                                child: Card(
                                    elevation: 5,
                                    margin: EdgeInsets.all(5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    child: ListTile(
                                      title: RichText(text: TextSpan(children: [
                                        TextSpan(text: "You were invited to the group:\n",
                                            style: TextStyle(color: Colors.grey,
                                                fontSize: 15)),
                                        TextSpan(text: documentSnapshot["groupname"],
                                            style: TextStyle(color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                        TextSpan(text: "\nCreated by: " + documentSnapshot["creator_name"],
                                            style: TextStyle(color: Colors.grey,
                                                fontSize: 10)),
                                      ])),//Text(documentSnapshot["groupname"]),
                                      leading: Stack(
                                          children: [
                                            Positioned(
                                                child: CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundImage:
                                                  NetworkImage(image_url + avatar_path),
                                                  backgroundColor: Colors.transparent,
                                                )
                                            ),
                                            Positioned( left: 20,
                                                child: CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundImage:
                                                  NetworkImage(image_url + avatar_path),
                                                  backgroundColor: Colors.transparent,
                                                )
                                            ),
                                            Positioned( left: 20,
                                                child: CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundImage:
                                                  NetworkImage(image_url + avatar_path),
                                                  backgroundColor: Colors.transparent,
                                                )
                                            ),

                                          ]
                                      ),
                                      trailing:

                                       ElevatedButton(
                                           onPressed: () async {
                                             await acceptRequest(
                                                 documentSnapshot["group_id"], documentSnapshot["groupname"], documentSnapshot["creator_id"], documentSnapshot["creator_name"], documentSnapshot["avatar_path"]
                                            );
                                             await deleteAcceptedRequest(documentSnapshot["group_id"]);
                                           },
                                            child: Text(
                                              'Accept',
                                              style: TextStyle(fontSize: 20, color: Colors.white),
                                            ),
                                            style:  ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                            ),

                                          //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        ),

                                /*trailing:
                                    IconButton(



                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          deleteTodos(documentSnapshot["groupname"]);
                                        }),
                                    */
                              ),
                            )
                        ));
                      });
                } else { print("I   F O U N D   T H E S E   G R O U P S :" + FirebaseFirestore.instance.collection("users").doc('${userID}/groups/').snapshots().toString());
                return Align(

                  alignment: FractionalOffset.bottomCenter,
                  child: CircularProgressIndicator(),
                );
                }
              }),



          StreamBuilder( // SENT REQUESTS PENDING
              stream: FirebaseFirestore.instance.collection("users/${userID}/sent_requests/").snapshots(),
              builder: (context, snapshots) {
                if (snapshots.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshots.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                        snapshots.data.documents[index];
                        return Dismissible(
                            onDismissed: (direction) {
                              deleteGroup(documentSnapshot["groupname"]);
                            },
                            key: Key(documentSnapshot["groupname"]),
                            child: Card(
                              elevation: 5,
                              margin: EdgeInsets.all(5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              child: ListTile(
                                title: RichText(text: TextSpan(children: [
                                  TextSpan(text: documentSnapshot["groupname"],
                                      style: TextStyle(color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  TextSpan(text: "\nYour invite is " + documentSnapshot["approved"],
                                      style: TextStyle(color: Colors.grey,
                                          fontSize: 15)),
                                ])),//Text(documentSnapshot["groupname"]),
                                leading: Stack(
                                    children: [
                                      Positioned(
                                          child: CircleAvatar(
                                            radius: 20.0,
                                            backgroundImage:
                                            NetworkImage(image_url + avatar_path),
                                            backgroundColor: Colors.transparent,
                                          )
                                      ),
                                      Positioned( left: 20,
                                          child: CircleAvatar(
                                            radius: 20.0,
                                            backgroundImage:
                                            NetworkImage(image_url + avatar_path),
                                            backgroundColor: Colors.transparent,
                                          )
                                      ),
                                      Positioned( left: 20,
                                          child: CircleAvatar(
                                            radius: 20.0,
                                            backgroundImage:
                                            NetworkImage(image_url + avatar_path),
                                            backgroundColor: Colors.transparent,
                                          )
                                      ),

                                    ]
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                                /*trailing:
                                    IconButton(



                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          deleteTodos(documentSnapshot["groupname"]);
                                        }),
                                    */
                              ),
                            ));
                      });
                } else { print("I   F O U N D   T H E S E   G R O U P S :" + FirebaseFirestore.instance.collection("users").doc('${userID}/groups/').snapshots().toString());
                return Align(

                  alignment: FractionalOffset.bottomCenter,
                  child: CircularProgressIndicator(),
                );
                }
              }),




              Card(
                  elevation: 5,
                  child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                title: Text("Choose group name:"),
                                content: Column(
                                    children: [
                                      TextField(
                                        onChanged: (String value) {
                                          groupname = value;
                                        },
                                      ),

                                      Text("\nAdd a group member (MEMBER ID):"),
                                      TextField(
                                        onChanged: (String value) {
                                          memberID_01 = value;
                                        },
                                      ),

                                    ]
                                ),


                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {

                                        //createGroup();
                                        sendRequest(uuid.v4());

                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Add"))
                                ],
                              );
                            });
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

              )

          ]

          ),

        floatingActionButton: FloatingActionButton(
              onPressed: () {
                checkRequest();
            },
          child: Icon(
              Icons.autorenew,
              color: Colors.white,
          ),
        ),
    );
  }
}
