import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;



Stack esclamazioni_02(
    BuildContext context) {

  Size screenSize = MediaQuery.of(context).size;
  return new Stack(
    alignment: Alignment.center,
    children: [

                          Container( // Scritta SHOUT
                              padding: new EdgeInsets.only(top: screenSize.height *0.45, left: screenSize.width *0.25,),

                              child: Transform.rotate(
                                      alignment: Alignment.topRight,
                                      angle: 0,
                                      child: DecoratedBox(
                                            position: DecorationPosition.background,
                                            decoration: BoxDecoration(
                                              color: ui.Color.fromARGB(0, 0, 0, 0),
                                              border: (

                                                  Border.all(
                                                      color: Colors.purpleAccent,
                                                      style: BorderStyle.solid,
                                                      width: 7.0,
                                              )
                                              ),
                                              borderRadius: BorderRadius.circular(14),
                                              shape: BoxShape.rectangle,

                                            ),



                                            child: Container(
                                              padding: EdgeInsets.all(15),
                                              child: Text(
                                                'SHOUT!',
                                                style: TextStyle(
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.purpleAccent,
                                                ),
                                              ),
                                            ),

                                          ),
                              )
                          ),


                          /*Container( // Scritta SAVE
                              //padding: new EdgeInsets.only(left:screenSize.width /1.8, bottom:screenSize.width),

                              child: Transform.rotate(
                                alignment: Alignment.topLeft,
                                angle: 0,
                                child: DecoratedBox(
                                  position: DecorationPosition.background,
                                  decoration: BoxDecoration(
                                    color: ui.Color.fromARGB(0, 0, 0, 0),
                                    border: (

                                        Border.all(
                                          color: Colors.lightBlueAccent,
                                          style: BorderStyle.solid,
                                          width: 7.0,
                                        )
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    shape: BoxShape.rectangle,

                                  ),



                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      'SAVE!',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ),
                                  ),

                                ),
                              )
                          ),*/ //scritta PASS, dislike


  ]
  ); //SCRITTE FADE IN COOL PASS SAVE SHOUT */


}
