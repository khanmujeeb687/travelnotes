import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travelnotes/main.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressBox extends StatefulWidget {
  String address;
  double fromtop;
  Position target;
  AddressBox(this.address,this.fromtop,this.target);
  @override
  _AddressBoxState createState() => _AddressBoxState();
}

class _AddressBoxState extends State<AddressBox> {

  Position _position;

  @override
  void initState() {
    _getcurrentloc();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 240),
      top:widget.fromtop,
      right: 10,
      left: 10,
      child: Hero(
        tag:"adr",
        child: Material(
          color: Colors.transparent,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Icon(Icons.location_on,color: red,size: 30,),
                      Flexible(
                        child: Text(widget.address,style: TextStyle(color: white),),
                      ),
                      IconButton(
                        icon: Icon(Icons.navigation,color: blue,size: 30,),
                        onPressed: _launchMapsUrl,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _launchMapsUrl() async {
if(_position==null)return;
    final url = 'https://www.google.com/maps/dir/?api=1&origin=${_position.latitude},${_position.longitude}&destination=${widget.target.latitude},${widget.target.longitude}&travelmode=driving';
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
