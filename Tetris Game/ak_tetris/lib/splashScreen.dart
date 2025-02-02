import 'dart:async';

import 'package:ak_tetris/gameScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  bool showText=true;
  Timer? txtTimer;
  double txtOpacity=1.0;

  late Animation animation;
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController=AnimationController(vsync: this,duration: const Duration(seconds: 2));
    animation=Tween(begin: 0.2, end: 1.0).animate(animationController);
    animationController.addListener((){
      setState(() {

      });
    });
    animationController.forward();

    Future.delayed(const Duration(seconds: 6),
        (){
      setState(() {
        showText=false;
        txtTimer=Timer.periodic(const Duration(seconds: 1), (timer){
          setState(() {
            txtOpacity=(txtOpacity==1.0?0.0:1.0);
          });
        });
      });
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body:
        Stack(
          alignment: Alignment.center,
          children: [
            InkWell(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GameScreen(),));
              },
              child: AnimatedOpacity(
                opacity: animation.value,
                  duration: const Duration(seconds: 12),
                  curve: Curves.bounceInOut,
                  child: Image.asset('assets/images/tetris.jpg',fit:BoxFit.fill,width: double.infinity,height: double.infinity,)),
            ),
             if(showText)
             Image.asset('assets/images/myLogo.png',fit:BoxFit.fill,width: double.infinity,height: double.infinity,)else
               AnimatedOpacity(
                 opacity: txtOpacity,
                 duration: const Duration(seconds: 1),
                 child: Padding(
                   padding: const EdgeInsets.only(bottom: 400.0),
                   child: InkWell(
                     onTap: (){
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GameScreen(),));
                     },
                       child: Text("Tap to Play",style: TextStyle(fontSize: 34,fontWeight: FontWeight.bold,color: Colors.purpleAccent),)),
                 ),
               ),

          ],
        )
    );
  }
}
