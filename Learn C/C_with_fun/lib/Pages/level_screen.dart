import 'package:c_with_fun/Pages/SelectionScreen.dart';
import 'package:c_with_fun/data/stage_model.dart';
import 'package:c_with_fun/data/stages_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'codeEditorScreen.dart';

class LevelScreen extends StatefulWidget {
  final Stage stage;

  LevelScreen({required this.stage});

  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  List<int> unlockedLevels = [];
  List<int> completedLevels = [];

  @override
  void initState() {
    super.initState();
    _loadLevelsStatus();
  }

  Future<void> _loadLevelsStatus() async {
    final prefs = await SharedPreferences.getInstance();
    unlockedLevels = prefs.getStringList('stage_${widget.stage.stageNumber}_levels')?.map(int.parse).toList() ?? [1];
    completedLevels = prefs.getStringList('stage_${widget.stage.stageNumber}_completed')?.map(int.parse).toList() ?? [];
    setState(() {});
  }

  Future<void> _updateLevelStatus(int levelNumber, bool completed) async {
    final prefs = await SharedPreferences.getInstance();

    if (completed) {
      if (!completedLevels.contains(levelNumber)) {
        completedLevels.add(levelNumber);
        await prefs.setStringList(
          'stage_${widget.stage.stageNumber}_completed',
          completedLevels.map((e) => e.toString()).toList(),
        );
      }

      // Unlock next level if it exists
      int nextLevel = levelNumber + 1;
      if (widget.stage.levels.any((l) => l.number == nextLevel) && !unlockedLevels.contains(nextLevel)) {
        unlockedLevels.add(nextLevel);
        await prefs.setStringList(
          'stage_${widget.stage.stageNumber}_levels',
          unlockedLevels.map((e) => e.toString()).toList(),
        );
      }

      // Check if all levels in the stage are completed
      if (completedLevels.length == widget.stage.levels.length) {
        await _unlockNextStage(widget.stage.stageNumber);
      }
    } else {
      completedLevels.remove(levelNumber);
      await prefs.setStringList(
        'stage_${widget.stage.stageNumber}_completed',
        completedLevels.map((e) => e.toString()).toList(),
      );
    }

    setState(() {});
  }

  Future<void> _unlockNextStage(int currentStage) async {
    final prefs = await SharedPreferences.getInstance();
    if (currentStage < stages.length) {
      List<String> unlockedStages = prefs.getStringList('unlocked_stages') ?? ['1'];

      String nextStage = (currentStage + 1).toString();
      if (!unlockedStages.contains(nextStage)) {
        unlockedStages.add(nextStage);
        await prefs.setStringList('unlocked_stages', unlockedStages);
      }

      print("Stage ${currentStage + 1} unlocked!");

      // ✅ Close LevelScreen and return true to SelectionScreen
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.stage.name} Levels",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple[400]!,
                Colors.blue[400]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 2,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple[400]!,
              Colors.blue[400]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: widget.stage.levels.length,
          itemBuilder: (context, index) {
            Level level = widget.stage.levels[index];
            bool isUnlocked = unlockedLevels.contains(level.number);
            bool isCompleted = completedLevels.contains(level.number);

            return Column(
              children: [
                Card(
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Level ${level.number}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                if (isCompleted)
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green[600],
                                    size: 24,
                                  ),
                                if (!isCompleted && isUnlocked)
                                  Icon(
                                    Icons.lock_open,
                                    color: Colors.green[600],
                                    size: 24,
                                  ),
                                if (!isUnlocked)
                                  Icon(
                                    Icons.lock,
                                    color: Colors.red[600],
                                    size: 24,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              level.problem,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.greenAccent,
                              ),
                            ),
                            SizedBox(height: 12),
                            if (isCompleted)
                              Text(
                                'Completed',
                                style: TextStyle(
                                  color: Colors.green[600],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (isUnlocked && !isCompleted)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CodeEditorScreen(
                                        prb: level.problem,
                                        expOut: level.expectedOutput,
                                        stage: widget.stage.stageNumber,
                                        level: level.number,
                                      ),
                                    ),
                                  );
                                  // Check the result after returning from the CodeEditorScreen
                                  if (result != null && result == true) {
                                    await _updateLevelStatus(level.number, true);
                                  } else {
                                    await _updateLevelStatus(level.number, false);
                                  }
                                },
                                child: Text("Start Level", style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal[600],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 7,
                                  shadowColor: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}
