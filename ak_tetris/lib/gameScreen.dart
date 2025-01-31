import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GameScreen extends StatefulWidget{
  static const int col=15;
  static const int row=25;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  var myScore=0;

  var bestScore=0;

  List<List<int>> tetrisPiece=[
    [0,7],
    [1,7],
    [1,6],
    [1,8]
  ];
  List<List<int>> nextPiece=[];
  List<List<int>>OccupiedBlocks=[];
  Timer ? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBestScore();
    nextPiece=createTetris();
    timer=Timer.periodic(const Duration(milliseconds: 500), (timer){
      setState(() {
        moveDown();
      });

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Your Score = $myScore",style: const TextStyle(color: Colors.greenAccent
                ),),
                Text("Best Score = $bestScore",style: const TextStyle(color: Colors.white),),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                elevation: 7,
                shadowColor: Colors.lightGreenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)
                )

              ),
              onPressed: (){
                Restart();
              },
                child:const Text("Restart",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),)
          ],
        ),
        backgroundColor: Colors.black,
      ),

      body:
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey[100]!, Colors.indigo[900]!],
        ),
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                height: 30,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.yellowAccent,width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.9),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 2), // Shadow effect below the screen
                    ),
                  ],

                ),
                child: const Center(child: Text("Next",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.cyanAccent,fontSize: 18),)),
              ),

              Container(
                height: 50,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.yellowAccent,width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.9),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 2), // Shadow effect below the screen
                    ),
                  ],
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      int c=index % 4;
                      int r=index ~/4;
                      //for adjust the real pieces position to next screen
                      int minRow= nextPiece.map((e) => e[0]).reduce(min);
                      int minCol= nextPiece.map((e) => e[1]).reduce(min);

                      bool isBlock= nextPiece.any((element) => element[0]-minRow==r && element[1]-minCol==c,);

                      return Container(
                        decoration: BoxDecoration(
                          color: isBlock? Colors.purpleAccent : Colors.black,
                          border: Border.all(color: Colors.black)
                        ),
                      );
                    },
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Container(
                  height: 393,
                  width: 350,
                  decoration: BoxDecoration(
                    border: Border.all(color:  Colors.yellowAccent,width: 5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.9),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 2), // Shadow effect below the screen
                      ),
                    ],
                  ),
                  //game part
                  child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: GameScreen.col),
                      itemCount: GameScreen.col*GameScreen.row,
                      itemBuilder: (context, index) {
                        int c= index % GameScreen.col;
                        int r= index ~/ GameScreen.col;

                        bool isTetrisBlock = tetrisPiece.any((block) => block[0]==r && block[1]==c);
                        bool isOccupiedBlock= OccupiedBlocks.any((block) => block[0]==r && block[1]==c);
                        return Container(
                         decoration: BoxDecoration(
                             color: isTetrisBlock ? Colors.greenAccent : isOccupiedBlock? Colors.red : Colors.black,
                           border: Border.all(color: Colors.black)
                         ),
                        );
                      },
                  ),

                ),
              ),
             const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          elevation: 7,
                          shadowColor: Colors.lightGreenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                      onPressed: (){
                          moveLeft();
                      },
                      child: const Icon(Icons.arrow_back_rounded,size: 30,color: Colors.black,)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 7,
                            shadowColor: Colors.lightGreenAccent,

                        ),
                          onPressed: (){
                          rotatePiece();
                          },
                          child: const Icon(Icons.sync,size: 52,color: Colors.black,)),
                      const SizedBox(
                        height: 50,
                      ),

                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              elevation: 7,
                              shadowColor: Colors.lightGreenAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              )
                          ),
                          onPressed: (){
                              moveDown();
                          },
                          child: const Icon(Icons.arrow_downward_rounded,size: 30,color: Colors.black,)),
                    ],
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          elevation: 7,
                          shadowColor: Colors.lightGreenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                      onPressed: (){
                          moveRight();
                      },
                      child: const Icon(Icons.arrow_forward_rounded,size: 30,color: Colors.black,))
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  bool canMoveDown(){
    return tetrisPiece.every(
         (block) {
           bool withinBoundary= block[0]+1 < GameScreen.row;
           bool notOccupied = ! OccupiedBlocks.any((element) => block[0]+1 == element[0] && block[1] == element[1] ,);
           //if next row of block and any collum not matches occupied

           return withinBoundary && notOccupied;
         },
    );

  }
  void moveDown() {
    if(canMoveDown()) {
      setState(() {
        for (int i = 0; i < tetrisPiece.length; i++) {
          tetrisPiece[i][0]++; //[i] iterates index, [0] means row, [1] means col
        }
      });
    }else{
      setState(() {
        OccupiedBlocks.addAll(tetrisPiece);
        ScoreUpdate();
        tetrisPiece=nextPiece;
        nextPiece=createTetris();

        if(!canSpawn(tetrisPiece)){
          setBestScore();
          ShowGameOverDialog();
        }
      });

    }

  }
  void moveRight() {
    bool canMoveRight= tetrisPiece.every(

          (block) => block[1]+1 < GameScreen.col && !OccupiedBlocks.any((element) => block[0]==element[0] && block[1]+1==element[1],),
    );
    if(canMoveRight && canMoveDown()){
      setState(() {
        for(int i=0; i<tetrisPiece.length; i++){
          tetrisPiece[i][1]++;
        }
      });
    }
  }
  void moveLeft() {
    bool canMoveLeft= tetrisPiece.every(
          (block) => block[1] > 0 && !OccupiedBlocks.any((element) => block[0]==element[0] && block[1]-1==element[1],),
    );
    if(canMoveLeft && canMoveDown()){
      setState(() {
        for(int i=0; i<tetrisPiece.length; i++){
          tetrisPiece[i][1]--;
        }
      });
    }
  }


  List<List<int>> createTetris(){
    final random= Random();
    List<List<List<int>>> pieces=[
      //Straight Line
      [
        [0,6],[0,7],[0,8],[0,9]
      ],
      //Square
      [
        [0,7],[0,8],
        [1,7],[1,8]
      ],
      //T shape
      [
              [0,7],
        [1,6],[1,7],[1,8],
      ],
      //L shape
      [
        [0,7],
        [1,7],
        [2,7],[2,8]
      ],
      //Reverse L shape
      [
        [0,8],
        [1,8],
        [2,8],[2,7]
      ],
      //Z shape vertical
      [
        [0,8],
        [1,8],[1,7],
        [2,7]
      ],
      //Reverse Z
      [
        [0,7],
        [1,7],[1,8],
              [2,8]
      ],
    ];
    
    return pieces[random.nextInt(pieces.length)];
  }
void ScoreUpdate(){
   List<int>completeRow=[];
    for(int r=0; r<GameScreen.row; r++){
      bool rowComplete=true;
      for(int c=0; c<GameScreen.col; c++){
        if(! OccupiedBlocks.any((element) => element[0]==r && element[1]==c)){
          rowComplete=false;
          break;
        }
      }
      
      if(rowComplete){
        completeRow.add(r);
      }
    }

    //update score
  if(completeRow.isNotEmpty){
    setState(() {
      myScore+=completeRow.length * 10;
      for(int row in completeRow){
        OccupiedBlocks.removeWhere((element) => element[0]==row);
      }

      for(int row in completeRow){
        for(int i=0; i<OccupiedBlocks.length; i++){
          if(OccupiedBlocks[i][0] < row){
            OccupiedBlocks[i][0]++;

          }
        }
      }
    });
  }
    
}

void Restart(){
    setState(() {
      OccupiedBlocks.clear();
      tetrisPiece=createTetris();
      nextPiece=createTetris();
      myScore=0;
      timer=Timer.periodic(const Duration(milliseconds: 500), (timer){
        timer.cancel();
        moveDown();
      });
    });
}

void rotatePiece(){
    setState(() {
      final pivot = tetrisPiece[0];
      List<List<int>>newPiece = [];

      for(var block in tetrisPiece){
        int newRow= pivot[0] - (block[1]- pivot[1]);
        int newCol=pivot[1] +(block[0]-pivot[0]);
        newPiece.add([newRow,newCol]);
      }
      if(canRotate(newPiece)){
        tetrisPiece=newPiece;
      }

    });
}
bool canRotate(List<List<int>>newPiece){
    return newPiece.every((block) {
      bool withinBounds= (block[0]>=0 &&
                block[0]<GameScreen.row &&
          block[1]>=0 &&
          block[1]<GameScreen.col
      );

      bool notColliding=! OccupiedBlocks.any((element) =>
        element[0]==block[0] && element[1]==block[1],);

          return withinBounds && notColliding;
    },);
}

bool canSpawn(List<List<int>>piece){
    return (
     piece.every((block) => !OccupiedBlocks.any((element) => element[0]==block[0] && block[1]==element[1],),)
    );
}


void ShowGameOverDialog(){
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) =>  AlertDialog(
          backgroundColor: Colors.black,
          title: const Column(
            children: [
              Icon(Icons.sentiment_very_dissatisfied_outlined,size: 60,color: Colors.yellowAccent,),
              SizedBox(height: 10,),
              Text("Game Over",textAlign: TextAlign.center,style: TextStyle(color: Colors.red,fontSize: 24,fontWeight: FontWeight.bold),),
            ],
          ),
          content: Text(
            "Your Score : $myScore\nBest Score : $bestScore",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.purpleAccent,fontSize: 18),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  elevation: 7,
                  shadowColor: Colors.lightGreenAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                  )

              ),
              onPressed: (){
                Navigator.pop(context);
                Restart();
              },
              child:const Text("Restart",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24),),),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  elevation: 7,
                  shadowColor: Colors.lightGreenAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                  )

              ),
              onPressed: (){
                SystemNavigator.pop();
              },
              child:const Text("Exit",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24)),)
          ],

        ),);
}
  void setBestScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (myScore > bestScore) {
      setState(() {
        bestScore = myScore;
      });
      prefs.setInt('bs', bestScore);
    }
  }

void getBestScore()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    bestScore=preferences.getInt('bs') ?? 0;
    setState(() {

    });
}

}

