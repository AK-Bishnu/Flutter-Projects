import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget{
   final String diff;
    MainScreen(this.diff);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {


  Random ran=Random();
  var score=0;
  var bestScore=0;
  static const int numClm=30;
  static const int numRw=30;

  List<Offset> snake=[Offset(5, 5),Offset(5, 4),Offset(5, 3)];
 //snake's initital position  (c,r)
  Offset food= Offset(10.0, 10.0);
  var currentDirection="down";
  Timer ? snakeMovingTimer;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBestScore();
    startGame();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Don't be a Snake!",),
        backgroundColor: Colors.blueAccent,
        elevation: 8,
        centerTitle: true,
      ),
      body:
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:   [Colors.blue.shade800, Colors.black]
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Your Score : $score\nBest Score : $bestScore",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.greenAccent),),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0,left: 70.0),
                  child: ElevatedButton(onPressed: (){
                    Restart();
                  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor:Colors.black,
                        elevation: 7,
                        shadowColor: Colors.lightGreenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),

                      ),
                      child: Text("Restart",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                )
              ],
            ),
            SizedBox(height: 23,),
            //Game Part
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.blue, Colors.black],
                    center: Alignment.center,
                    radius: 1.0,
                  ),
                ),
                child: GridView.builder(
                    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:numClm,
        
                    ),
                    itemCount: numClm*numRw,
                    itemBuilder: (context,index){
        
                      final row= index ~/ numClm; //~/ for normal / in c
                      final clm=index % numClm;
        
                      final currenPos= Offset(clm.toDouble(), row.toDouble());
        
                      bool isSnakePart= snake.contains(currenPos);
                      bool isHead= snake.isNotEmpty && snake.first==currenPos;
                      bool isFood= (food == currenPos);
                      return Container(
                        decoration: BoxDecoration(
                          color: isHead? Colors.yellowAccent : isSnakePart? Colors.green :  isFood? Colors.pink.shade300 : Colors.black,
                          border:  Border.all(
                            color: Colors.black,
                          )
                        ),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0,top: 39.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    changeDirection("left");
                  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor:Colors.black,
                        elevation: 6,
                        shadowColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
        
                      ),
                      child: Icon(Icons.keyboard_arrow_left,size: 50,)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: (){
                        changeDirection("up");
                      },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            foregroundColor:Colors.black,
                            elevation: 6,
                            shadowColor: Colors.greenAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
        
                          ),
                          child: Icon(Icons.keyboard_arrow_up,size: 50,)),
                      SizedBox(height: 30,),
        
                      ElevatedButton(onPressed: (){
                        changeDirection("down");
                      },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            foregroundColor:Colors.black,
                            elevation: 6,
                            shadowColor: Colors.greenAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
        
                          ),
                          child: Icon(Icons.keyboard_arrow_down,size: 50,)),
                    ],
                  ),
        
                  ElevatedButton(onPressed: (){
                    changeDirection("right");
                  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor:Colors.black,
                        elevation: 6,
                        shadowColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
        
                      ),
                      child: Icon(Icons.keyboard_arrow_right,size: 50,)),
                ],
              ),
            ),
        
          ],
        ),
      )
    );

  }

  void generateFood(){
    int col= ran.nextInt(numClm);
    int row=ran.nextInt(numRw);

    Offset newFood= Offset(col.toDouble(), row.toDouble());

    if(snake.contains(newFood))
      generateFood();
    else
      food=newFood;
  }

  void moveSnake(){
    setState(() {
      Offset newHead=snake.first;
      if(currentDirection=="up")
        newHead=Offset(newHead.dx, newHead.dy-1);
      else if(currentDirection=="down")
        newHead=Offset(newHead.dx, newHead.dy+1);
      else if(currentDirection=="left")
        newHead=Offset(newHead.dx-1, newHead.dy);
      else if(currentDirection=="right")
        newHead=Offset(newHead.dx+1, newHead.dy);

      var newHeadX=newHead.dx;
      var newHeadY=newHead.dy;

      if(newHeadX<0)
        newHeadX=numClm - 1;
      else if(newHeadX >=numClm)
        newHeadX=0;

      if(newHeadY<0)
        newHeadY=numRw - 1;
      else if(newHeadY >=numRw)
        newHeadY=0;

      newHead=Offset(newHeadX.toDouble(), newHeadY.toDouble());

      if(snake.contains(newHead)){
        showGameOver();
        snakeMovingTimer?.cancel();
        return;
      }

      snake.insert(0, newHead);

      if(newHead==food){
        generateFood();
        updateScore();
      }
      else
        snake.removeLast();
    });
  }

  void changeDirection(String newDirection){
    if((currentDirection == "up" && newDirection!="down") ||
        (currentDirection == "down" && newDirection!="up") ||
        (currentDirection == "left" && newDirection!="right") ||
        (currentDirection == "right" && newDirection!="left")
    ){
      setState(() {
        currentDirection=newDirection;
      });
      moveSnake();
    }
  }

  void startGame() {
    var speed;
    if(widget.diff=="easy")
      speed=300;
    else  if(widget.diff=="medium")
      speed=150;
    else if(widget.diff=="hard")
      speed=80;
    snakeMovingTimer =  Timer.periodic(Duration(milliseconds: speed), (timer){
      moveSnake();
    });
  }

  void showGameOver() {
    updateBestScore();
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) =>AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.grey[900],
          title: Column(
            children: [
              Icon(Icons.sentiment_very_dissatisfied_outlined,size: 60,color: Colors.redAccent,),
              SizedBox(height: 10,),
              Text("Game Over",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
            ],
          ),
          content: Text("Your Score :$score\nBest Score : $bestScore",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white70),),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
              Restart();
            },
                style:ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.greenAccent,
                  elevation: 7

                ),
                child: Text("Restart",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),),
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
            },style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
                shadowColor: Colors.redAccent,
                elevation: 7
            ), child: Text("Exit",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),))
          ],
        ),);
  }

  void Restart(){
    setState(() {
      score=0;
      snake=[Offset(5, 5),Offset(5, 4),Offset(5, 3)];
      food= Offset(10.0, 10.0);
      currentDirection="down";
      startGame();
    });
  }

  void updateScore(){
    if(widget.diff=="easy")
      score++;
    else if(widget.diff=="medium")
      score+=2;
    else if(widget.diff=="hard")
      score+=3;

  }

  void loadBestScore() async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    setState(() {
      bestScore= prefs.getInt('bs') ?? 0;
    });
  }
  void saveBestScore() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setInt('bs', bestScore);
  }
  void updateBestScore(){
    if(score> bestScore){
      setState(() {
        bestScore=score;
      });
      saveBestScore();
    }
  }

}
