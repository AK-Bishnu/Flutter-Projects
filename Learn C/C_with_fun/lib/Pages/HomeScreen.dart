import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SelectionScreen.dart';

class Homescreen extends StatefulWidget {
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  var Opacity = 1.0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    toggleText();
  }

  void toggleText() {
    Timer.periodic(
      Duration(seconds: 1),
          (timer) => setState(() {
        Opacity = (Opacity == 1.0 ? 0.0 : 1.0);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: InkWell(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => selectionScreen(),
              ));
        },
        child: Stack(children: [
          Container(
            height: h,
            width: w,
            child: Image.asset(
              'assets/homescreen.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              bottom: 110,
              left: 100,
              child: AnimatedOpacity(
                duration: Duration(seconds: 1),
                opacity: Opacity,
                child: Text(
                  "Tap to Begin",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ))
        ]),
      ),
    );
  }
}
