import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResultScreen extends StatelessWidget {
  final bool isSuccess;
  final String ActOut;
  final String ExpOut;
  final VoidCallback onContinue;
  final VoidCallback onRetry;

  ResultScreen({
    super.key,
    required this.isSuccess,
    required this.ActOut,
    required this.ExpOut,
    required this.onContinue,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lottie Animation
                Lottie.asset(
                  isSuccess
                      ? 'assets/happyAnimation.json'
                      : 'assets/sadAnimation.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),

                // Success/Failure Text
                Text(
                  isSuccess ? "Great Job! 🎉" : "Oops! Try Again 😢",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: isSuccess ? Colors.greenAccent : Colors.redAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Output Text
                _buildOutputText("Your Output: $ActOut"),
                const SizedBox(height: 15),
                _buildOutputText("Expected Output: $ExpOut"),
                const SizedBox(height: 40),

                // Conditional Button: Continue for Success, Retry for Failure
                ElevatedButton(
                  onPressed: isSuccess ? onContinue : onRetry,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                    isSuccess ? Colors.green : Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8,
                  ),
                  child: Text(
                    isSuccess ? "Continue" : "Retry",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Back Button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Back",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutputText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }
}
