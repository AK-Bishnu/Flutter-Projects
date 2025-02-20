import 'package:flutter/material.dart';
import 'package:c_with_fun/Pages/resultantScreen.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/cpp.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';  // ✅ Import SharedPreferences

class CodeEditorScreen extends StatefulWidget {
  final String prb;
  final String expOut;
  final int stage;  // ✅ Added stage number
  final int level;  // ✅ Added level number

  CodeEditorScreen({super.key, required this.prb, required this.expOut, required this.stage, required this.level});

  @override
  CodeEditorScreenState createState() => CodeEditorScreenState();
}

class CodeEditorScreenState extends State<CodeEditorScreen> {
  CodeController? _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: '''#include <stdio.h>
int main() {

    return 0;
}''',
      language: cpp,
    );
  }

  Future<void> compileCCode(String code) async {
    var url = Uri.parse('https://api.jdoodle.com/v1/execute');

    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      'clientId': '5ae29629f95d8fa4fc1c597d6323b09',
      'clientSecret': '91e58d6d61146cf8d376d3a10c195edb481d1327891e275f58f737515dca2dee',
      'script': code,
      'language': 'c',
      'versionIndex': '0',
    });

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        String actualOutput = responseData['output'].trim();
        String expOutput = widget.expOut.trim();

        // Normalize whitespace
        actualOutput = actualOutput.replaceAll(RegExp(r'\s+'), ' ');
        expOutput = expOutput.replaceAll(RegExp(r'\s+'), ' ');

        bool isCorrect = (actualOutput == expOutput);

        if (isCorrect) {
          await unlockNextLevel(widget.stage, widget.level);  // ✅ Unlock next level
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              isSuccess: isCorrect,
              ExpOut: expOutput,
              ActOut: actualOutput,
              onContinue:() async{
                await unlockNextLevel(widget.stage, widget.level);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => ,),
                    (route) => false,
                );
              },
              onRetry: () => Navigator.pop(context),
            ),
          ),
        );
      } else {
        _showError('Failed to compile code. Status: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  /// 🔓 Unlocks the next level
  Future<void> unlockNextLevel(int stage, int level) async {
    final prefs = await SharedPreferences.getInstance();
    int nextLevel = level + 1;
    await prefs.setBool('stage_${stage}_level_$nextLevel', true);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _runCode() {
    String userCode = _codeController!.text;
    compileCCode(userCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("C Code Editor"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              children: [
                // Problem Statement Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Problem Statement:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 8),
                      Text(widget.prb, style: TextStyle(fontSize: 14, color: Colors.white)),
                      SizedBox(height: 15),
                      Text("Expected Output:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Text(widget.expOut, style: TextStyle(fontSize: 14, color: Colors.green)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),

                // Code Editor
                Container(
                  height: 300,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CodeField(
                    controller: _codeController!,
                    textStyle: TextStyle(fontFamily: 'SourceCode', color: Colors.white),
                    background: Colors.black,
                  ),
                ),
                SizedBox(height: 20),

                // Run Code Button
                ElevatedButton(
                  onPressed: _runCode,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white, size: 24),
                      SizedBox(width: 10),
                      Text("Run Code", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
