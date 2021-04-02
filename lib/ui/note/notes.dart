import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travelnotes/ui/note/addnote.dart';
import 'package:travelnotes/util/databasehelper.dart';

import '../../main.dart';


class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List<Map> _notes;
bool show;
  @override
  void initState() {
    show=false;
    // TODO: implement initState
    _getAllNotes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        title: Text("Notes",style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: black,
      body: Container(
        color: black,
        child: Hero(
          tag:"adr",
          child: Material(
            color: Colors.transparent,
            child: show?GridView.count(crossAxisCount: 2,
            children:List.generate(_notes.length, (index){
              return Material(
                color: black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
                child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        color: white.withOpacity(0.5),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Text(_notes[index]["address"],
                                style: TextStyle(
                                    color: whitetext),
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Text(_notes[index]["note"],
                                style: TextStyle(
                                    color: whitetext),
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute<String>(builder:(context){
                          return AddNote(
                              _notes[index]["address"],
                              Position(latitude:double.parse(_notes[index]["lat"]),
                                  longitude:double.parse(_notes[index]["long"]) ),
                          _notes[index]["note"],
                            _notes[index]["id"]
                          );
                        }
                        )
                    ).then((value){
                      _getAllNotes();
                    });
                  },
                  onLongPress: (){
                      showDialog(context: context,
                      builder: (context){
                        return ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),
                            child: AlertDialog(
                              backgroundColor: grey.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)
                              ),
                              title: Text("Delete Note",style: TextStyle(color: grey)),
                              actions: <Widget>[
                                RaisedButton(
                                  color: black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)
                                  ),
                                  child: Text("Delete",style: TextStyle(color: grey)),
                                  onPressed: (){
                                    var db=new databasehelper();
                                    db.deleteuser((_notes[index]["id"]).toString());
                                    _getAllNotes();
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      );
                  },
                ),
              );
            }),
            ):Center(
              child: Text("No Notes!",
              style: TextStyle(
                color: white,
                fontWeight: FontWeight.w600,
                fontSize: 30
              ),
              ),
            ),
          ),
        ),
      ),
    );

  }

  _getAllNotes()async{
    var db=new databasehelper();
      _notes=await db.AllUsers();
      setState(() {
        _notes=_notes;
        show=true;
        if(_notes.isEmpty){
show=false;
        }
      });
  }

}
