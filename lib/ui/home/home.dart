import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travelnotes/main.dart';

import 'addressbox.dart';
import 'bottomnavigation.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Position _position;
  Position _initialposition;
  String _address;
  String pincode;
  double pinpill;
  int a;
  bool move=true;


  static const LatLng _center = const LatLng(28.555229, 77.285257);
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _mapController = Completer();
  MapType _currentMapType = MapType.normal;
  GoogleMapController _mapcontroller;


  @override
  void initState() {
    pinpill=-500;
    a=0;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: Set<Marker>.of(_markers.values),
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12.0,
            ),
            myLocationEnabled: true,
            onCameraMove: _oncameramove,
            mapType: _currentMapType,
            onCameraIdle: (){
              if(a==1){
                setState(() {
                  _getgeocodedaddress(_position);
                  pinpill=80;
                });
                a=0;
              }

            },
          ),

          _address!=null?AddressBox(_address,pinpill,_position):Container(),
          _address!=null?BddressBox(pinpill,_address,_position,this.maptypecallback):Container(),
        ],
      ),

    );
  }

  maptypecallback(){
    setState(() {
      _currentMapType=_currentMapType==MapType.normal?MapType.satellite:MapType.normal;
    });
  }




  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



  void _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    _mapcontroller=controller;
    getcurrentlocation();
  }

  _addusermarker(Position position)
  {
    MarkerId markerId = MarkerId("mid");
    Marker marker = Marker(
        markerId: markerId,
        position: LatLng(position.latitude,position.longitude),
        draggable: false,
        icon: BitmapDescriptor.fromAsset("assets/newmarker.png")
    );
    if(!mounted) return;
    setState(() {
      _markers[markerId] = marker;
    });

  }



  getcurrentlocation() async {
    _position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    if (_position == null) {
      _position = await Geolocator().getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    }
    if(_initialposition==null){
      _initialposition=_position;
    }
    _getgeocodedaddress(_position);
  }

  _getgeocodedaddress(Position position)async{
    _position=Position(latitude:position.latitude,longitude: position.longitude);
    if(!mounted) return;
    if(move){
      _mapcontroller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_position.latitude,_position.longitude),
            zoom: 18,
          ),
        ),
      );
      move=false;
    }
    final coordinates = new Coordinates(
        position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    if(!mounted) return;
    setState(() {
      pinpill=50;
      _address=first.addressLine;
      pincode=first.postalCode;
    });
    _addusermarker(_position);

  }


  void _oncameramove(CameraPosition position) {
    a=1;
    _position=Position(latitude: position.target.latitude,longitude: position.target.longitude);
    if(_markers.length > 0) {
      MarkerId markerId = MarkerId("mid");
      Marker marker = _markers[markerId];
      Marker updatedMarker = marker.copyWith(
        positionParam: position.target,
      );
      if(!mounted) return;
      setState(() {
        pinpill=-500;
        _markers[markerId] = updatedMarker;
      });

    }
  }

}


