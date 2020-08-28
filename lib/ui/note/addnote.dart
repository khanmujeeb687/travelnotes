import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travelnotes/ui/home/addressbox.dart';
import 'package:travelnotes/util/databasehelper.dart';
import 'package:travelnotes/util/user.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';


class AddNote extends StatefulWidget {
  int id;
  String address;
  Position postion;
  String note;
  AddNote(this.address,this.postion,this.note,this.id);
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController _controller;
Position _position;
  @override
  void initState() {
    _controller=TextEditingController(text: widget.note!=null?widget.note:"");
    _getcurrentloc();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        if(_controller.text.isNotEmpty){
          _savenote("");
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 50),
          padding: EdgeInsets.all(6),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Hero(
                      tag:"adr",
                      child: Material(
                        color: Colors.transparent,
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
                                    icon: Icon(Icons.navigation,color: blue,size: 30,),
                                    onPressed: _launchMapsUrl,
                                  ),
                                  Flexible(
                                    child: Text(widget.address,style: TextStyle(color: white),),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.save,color: blue,size: 30,),
                                    onPressed:(){
                                      _savenote("success");
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: "Write something here..",
                    contentPadding: EdgeInsets.only(top: 50,left: 20)
                    ),
                    style: TextStyle(
                      color: white
                    ),
                    scrollPadding: EdgeInsets.all(20.0),
                    keyboardType: TextInputType.multiline,
                    maxLines: 99999,
                    autofocus: true,
                  )
                ],
              ),
            ),
          ),
        ),
        resizeToAvoidBottomPadding: true,
      ),
    );
  }


  _savenote(texter) async{
    String note=_controller.text;
    String lat=widget.postion.latitude.toString();
    String long=widget.postion.longitude.toString();
    String time=DateTime.now().millisecondsSinceEpoch.toString();
    String address=widget.address;

    var db=new databasehelper();
    if(widget.note==null){
      db.insertuser(User(lat, long, address, note, time));
    }
    else if(widget.id!=null){
      db.updateuser(User.map({
        "lat":lat,
        "long": long,
        "address": address,
        "note":note,
        "time": time,
        "id": widget.id
      }));
    }
    print("note added");
    Navigator.pop(context,texter);
  }
  void _launchMapsUrl() async {
    if(_position==null)return;
    final url = 'https://www.google.com/maps/dir/?api=1&origin=${_position.latitude},${_position.longitude}&destination=${widget.postion.latitude},${widget.postion.longitude}&travelmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _getcurrentloc() async{
    _position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    if (_position == null) {
      _position = await Geolocator().getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    }
  }


}
