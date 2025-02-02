import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_snakes/dificultyScreen.dart';
import 'package:hello_snakes/mainScreen.dart';


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
      home: const SplashScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.title});

  final String title;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  late Animation animation;
  late AnimationController animationController;

  var showText=false;
  Timer ?txtTimer;
  double txtOpacity=1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController=AnimationController(vsync: this, duration: Duration(seconds: 4));
    animation=Tween(begin: 0.0, end: 1.0).animate(animationController);
    animationController.addListener((){
      setState(() {

      });
    });
    animationController.forward();

    Future.delayed(
      Duration(seconds: 8),
        (){
        setState(() {
          showText=true;

          txtTimer=Timer.periodic(Duration(seconds: 1), (timer){
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
        body: Stack(
          alignment: Alignment.bottomCenter,
          children:[
            AnimatedOpacity(
            opacity: animation.value,
            duration: Duration(seconds: 4),
            curve: Curves.bounceIn,
            child: Container(
              height: double.infinity,
              width: double.infinity,

              child: Image.asset('assets/images/OIP.jpg',fit: BoxFit.fill,),
            ),
          ),
            if(showText)
              AnimatedOpacity(
                opacity: txtOpacity,
                duration: Duration(milliseconds: 500),
                child: InkWell(
                    onTap: (){
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => DificultyScreen(),));
                }, child: Text("Tap to begin",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
              )
            else
              Text("Ak Bishnu",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)

              ]
        ),
    );
  }
}
