import 'package:c_with_fun/Pages/codeEditorScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrintMaster extends StatefulWidget {
  @override
  _PrintMasterState createState() => _PrintMasterState();
}

class _PrintMasterState extends State<PrintMaster> {
  final List<Map<String, String>> tasks = [
    {
      "task": "1",
      "problem": "Print 'Hello, World!'",
      "output": "Hello, World!\n"
    },
    {
      "task": "2",
      "problem": "Print Multiple Lines",
      "output": "Welcome to Print Master!\nLet's learn C together.\n"
    },
    {
      "task": "3",
      "problem": "Print a Shape (Triangle)",
      "output": "  *  \n *** \n*****\n"
    },
    {
      "task": "4",
      "problem": "Print Special Characters",
      "output": "C uses \"printf\" to print output.\nThe percentage symbol: %\nThe backslash: \\\n"
    },
    {
      "task": "5",
      "problem": "Print a Number Using a Variable",
      "output": "The number is 25\n"
    },
  ];

  List<int> unlockedLevels = [];

  @override
  void initState() {
    super.initState();
    _loadUnlockedLevels();
  }

  // Load unlocked levels from SharedPreferences
  Future<void> _loadUnlockedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      unlockedLevels = prefs.getStringList('unlocked_levels')
          ?.map((e) => int.parse(e))
          .toList() ?? [1]; // Level 1 is unlocked by default
    });
  }

  // Unlock the next level
  Future<void> _unlockNextLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    if (!unlockedLevels.contains(level)) {
      unlockedLevels.add(level);
      await prefs.setStringList(
          'unlocked_levels', unlockedLevels.map((e) => e.toString()).toList());
      setState(() {});
    }
  }

  // Check if a task is unlocked
  bool _isLevelUnlocked(int level) {
    return unlockedLevels.contains(level);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                title: const Text(
                  "Print Master: Learn C Printing",
                  style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                centerTitle: true,
                elevation: 3,
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 20),
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      int taskLevel = int.parse(tasks[index]["task"]!);
                      return taskCard(
                        taskNumber: tasks[index]["task"]!,
                        problem: tasks[index]["problem"]!,
                        sampleOutput: tasks[index]["output"]!,
                        levelUnlocked: _isLevelUnlocked(taskLevel),
                        onLevelComplete: () =>
                            _unlockNextLevel(taskLevel +
                                1), // Unlock next level
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget taskCard({
    required String taskNumber,
    required String problem,
    required String sampleOutput,
    required bool levelUnlocked,
    required Function onLevelComplete,
  }) {
    return Builder(
      builder: (context) {
        int taskLevel = int.parse(taskNumber);
        int currentStage = 1; // You can set the appropriate stage here based on your requirements

        return InkWell(
          onTap: levelUnlocked
              ? () async {
            // Navigate to the code editor screen when the task is unlocked
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CodeEditorScreen(
                      prb: problem,
                      expOut: sampleOutput,
                      stage: currentStage, // Pass the stage number
                      level: taskLevel, // Pass the level number
                    ),
              ),
            );

            // If the task is completed successfully, unlock the next task
            if (result == true) {
              onLevelComplete();
            }
          }
              : null, // Disable tap if level is locked
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: levelUnlocked ? Colors.grey.shade900 : Colors.grey.shade700,
            // Darker color for locked tasks
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Number and Problem
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Task $taskNumber',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          problem,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Sample Output
                  const Text(
                    "📌 Expected Output:",
                    style: TextStyle(fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      sampleOutput,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  // Lock/Unlock Indicator
                  if (!levelUnlocked)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
