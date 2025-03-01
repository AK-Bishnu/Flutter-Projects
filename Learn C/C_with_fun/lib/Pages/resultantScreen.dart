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
              mainAxisAlignment: MainAxisAlignment.start,
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

                // Output Section in Column (Expected Output above, Your Output below)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // "Expected Output" Section
                    _buildOutputCard("Expected Output", ExpOut),

                    const SizedBox(height: 20), // Space between sections

                    // "Your Output" Section
                    _buildOutputCard("Your Output", ActOut),
                  ],
                ),
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
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom method to build the output cards
  Widget _buildOutputCard(String title, String output) {
    return Card(
      elevation: 8,
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12), // Adjusted padding
              width: double.infinity,
              height: 50, // Reduced height for terminal-like look
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white38,
                  width: 1.5,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Horizontal scroll
                child: Text(
                  output,
                  style: TextStyle(
                    fontFamily: 'Courier New', // Monospaced font for terminal-like look
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
