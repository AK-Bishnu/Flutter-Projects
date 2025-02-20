import 'package:c_with_fun/Pages/taskPages/printMaster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class selectionScreen extends StatefulWidget {
  @override
  State<selectionScreen> createState() => _selectionScreenState();
}

class _selectionScreenState extends State<selectionScreen> {
  List<bool> unlockedStages = [true, false, false, false]; // First stage is open

  @override
  void initState() {
    super.initState();
    _loadUnlockedStages();
  }

  /// Load unlocked stages from SharedPreferences
  Future<void> _loadUnlockedStages() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 1; i < unlockedStages.length; i++) {
        unlockedStages[i] = prefs.getBool('stage_$i') ?? false;
      }
    });
  }

  /// Unlock next stage when all levels of the previous stage are completed
  Future<void> unlockNextStage(int stage) async {
    final prefs = await SharedPreferences.getInstance();
    int nextStage = stage + 1;
    if (nextStage < unlockedStages.length) {
      await prefs.setBool('stage_$nextStage', true);
      setState(() {
        unlockedStages[nextStage] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Choose Level",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          stageButton(0, 'assets/print.jpeg', 'Print Master',
              'Master the print statement to display output.', PrintMaster()),
          Divider(),
          stageButton(1, 'assets/variable.jpeg', 'The Variable Lab',
              'Experiment with declaring and working with variables.', null),
          Divider(),
          stageButton(2, 'assets/loops.jpeg', 'Loop Explorer',
              'Dive into loops and learn how to repeat tasks efficiently.', null),
          Divider(),
          stageButton(3, 'assets/functions.jpeg', 'Return to Functions',
              'Learn how to return values from functions and use them in programs.', null),
        ],
      ),
    );
  }

  Widget stageButton(int index, String imagePath, String name, String description, Widget? nextScreen) {
    return InkWell(
      onTap: unlockedStages[index] && nextScreen != null
          ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => nextScreen))
          : null,
      child: Opacity(
        opacity: unlockedStages[index] ? 1.0 : 0.4, // Dim locked stages
        child: listContainers(imagePath, name, description),
      ),
    );
  }

  Widget listContainers(String imagePath, String name, String description) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 280,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage(imagePath),
          ),
          Text(name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
                shadows: [
                  Shadow(
                    blurRadius: 8.0,
                    color: Colors.cyan.withOpacity(0.7),
                    offset: Offset(2, 2),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

