import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travelnotes/main.dart';
import 'package:travelnotes/ui/info.dart';
import 'package:travelnotes/ui/note/addnote.dart';
import 'package:travelnotes/ui/note/notes.dart';

class BddressBox extends StatefulWidget {
  String address;
  double fromtop;
  Position position;
  Function maptypecallback;
  BddressBox(this.fromtop,this.address,this.position,this.maptypecallback);
  @override
  _BddressBoxState createState() => _BddressBoxState();
}

class _BddressBoxState extends State<BddressBox> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 240),
      bottom:widget.fromtop-40,
      right: 10,
      left: 10,
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 5,sigmaX: 5),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: grey.withOpacity(0.4)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit,color: blue,size: 30,),
                    onPressed: (){
                      Navigator.push(context,
                      MaterialPageRoute<String>(builder:(context){
                            return AddNote(widget.address,widget.position,null,null);
                          }
                      )
                      ).then((value){
                        if(value=="success"){
                          Navigator.push(context,
                              MaterialPageRoute<String>(builder:(context){
                                return Notes();
                              }
                              )
                          );
                        }
                      });
                    },
                  ),
                 IconButton(
                    icon: Icon(Icons.satellite,color: blue,size: 30,),
                    onPressed:widget.maptypecallback,
                  ),
                 IconButton(
                    icon: Icon(Icons.note,color: blue,size: 30,),
                    onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder:(context){
                            return Notes();
                          }
                          )
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
