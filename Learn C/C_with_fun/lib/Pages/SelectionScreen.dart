import 'package:c_with_fun/data/stages_data.dart';
import 'package:flutter/material.dart';
import 'level_screen.dart'; // This will handle the levels inside a stage

class SelectionScreen extends StatefulWidget {
  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  @override
  void initState() {
    super.initState();
    // No need for any unlocking logic here now.
  }

  // Navigate to the LevelScreen
  Future<void> navigateToLevelScreen(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelScreen(stage: stages[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Stage", style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView.builder(
        itemCount: stages.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => navigateToLevelScreen(index), // All stages are now accessible

            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 280,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage(stages[index].imagePath),
                  ),
                  Text(
                    stages[index].name,
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      stages[index].description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
