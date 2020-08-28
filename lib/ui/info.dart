import 'package:flutter/material.dart';

import '../main.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        title: Text("Info",style: TextStyle(color: white),),
        backgroundColor: black,
      ),
      body: Container(
        color: black,
      ),
    );
  }
}
