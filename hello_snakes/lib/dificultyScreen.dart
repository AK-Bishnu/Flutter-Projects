import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_snakes/mainScreen.dart';

class DificultyScreen extends StatefulWidget{
  @override
  State<DificultyScreen> createState() => DificultyScreenState();
}

class DificultyScreenState extends State<DificultyScreen> {
  Timer?txtTimer;
  double txtOpacity=1.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtTimer=Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        txtOpacity= (txtOpacity==1 ? 0.0 :1.0);
      });
    });
  }

  String selectedDifficulty="easy";
  final Map<String,String> difficultyLabels={
    "easy":"Easy",
    "medium":"Medium",
    "hard":"Hard",

  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: [Colors.red,Colors.green,Colors.black],
            center: Alignment.center,
            stops: [0.2,0.6,1.0],
            radius: 0.5
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Select Difficulty Level",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
            SizedBox(height: 20,),
            Column(
              children: [
                difficultyOption("easy"),
                difficultyOption("medium"),
                difficultyOption("hard"),
              ],
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(right: 10.0,),
              child: ElevatedButton(onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainScreen(selectedDifficulty),));
              },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor:Colors.black,
                    elevation: 10,
                    shadowColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),

                  ),
                  child: AnimatedOpacity(
                      duration: Duration(milliseconds: 400),
                      opacity: txtOpacity,
                      child: Text("Start Game",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),)),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget difficultyOption(String difficulty){
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 100),
        child: SizedBox(
          child: Row(
            children: [
              Transform.scale(
                scale: 1.5,

                child: Radio(
                  activeColor: Colors.black,
                    focusColor: Colors.blue,
                    value: difficulty,
                    groupValue: selectedDifficulty,
                    onChanged: (value){
                      setState(() {
                        selectedDifficulty=value!;
                      });
                    }
                ),
              ),
              Text(difficultyLabels[difficulty]!,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}

