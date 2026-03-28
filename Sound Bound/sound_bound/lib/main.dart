import 'package:flutter/material.dart';
import 'package:sound_bound/mcScreen.dart';
import 'host/presentation/host_screen.dart';
import 'client/presentation/client_screen.dart';

void main() {
  const isHost = bool.fromEnvironment('IS_HOST', defaultValue: false);
  runApp(MyApp(isHost: isHost));
}

class MyApp extends StatelessWidget {
  final bool isHost;
  const MyApp({super.key, required this.isHost});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SoundBound Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isHost ? HostScreen() : ClientScreen(),
    );
  }
}
