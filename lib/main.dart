import 'package:flutter/material.dart';
import 'package:travelnotes/ui/home/home.dart';


Color grey=Colors.grey;
Color red=Colors.redAccent[100];
Color blue=Colors.blueGrey[800];
Color bluedark=Colors.blueGrey[900];
Color white=Colors.grey[800];
Color black=Colors.black87;
Color whitetext=Colors.white70;


void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Travel Notes",
      home:Home(),
    )
  );
}
