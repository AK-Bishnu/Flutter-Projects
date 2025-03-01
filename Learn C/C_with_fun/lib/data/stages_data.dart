import 'stage_model.dart';

List<Stage> stages = [
  Stage(
    stageNumber: 1,
    name: "Print Master",
    description: "Master the print statement to display output.",
    imagePath: "assets/print.jpeg",
    levels: [
      Level(number: 1, problem: "Print 'Hello, World!'", expectedOutput: "Hello, World!\n"),
      Level(number: 2, problem: "Print Multiple Lines", expectedOutput: "Welcome to Print Master!\nLet's learn C together.\n"),
      Level(number: 3, problem: "Print a Shape (Triangle)", expectedOutput: "  *  \n *** \n*****\n"),
    ],
  ),
  Stage(
    stageNumber: 2,
    name: "The Variable Lab",
    description: "Experiment with declaring and working with variables.",
    imagePath: "assets/variable.jpeg",
    levels: [
      Level(number: 1, problem: "Declare an integer variable 'x' with value 10 and print it.", expectedOutput: "10\n"),
      Level(number: 2, problem: "Declare a float variable 'y' with value 3.14 and print it.", expectedOutput: "3.14\n"),
      Level(number: 3, problem: "Declare a string variable 'name' with value 'Alice' and print it.", expectedOutput: "Alice\n"),
    ],
  ),
  Stage(
    stageNumber: 3,
    name: "Loop Explorer",
    description: "Dive into loops and learn how to repeat tasks efficiently.",
    imagePath: "assets/loops.jpeg",
    levels: [
      Level(number: 1, problem: "Print numbers from 1 to 5 using a for loop.", expectedOutput: "1\n2\n3\n4\n5\n"),
      Level(number: 2, problem: "Print all even numbers from 0 to 10 using a while loop.", expectedOutput: "0\n2\n4\n6\n8\n10\n"),
      Level(number: 3, problem: "Print a countdown from 5 to 1 using a do-while loop.", expectedOutput: "5\n4\n3\n2\n1\n"),
    ],
  ),
  Stage(
    stageNumber: 4,
    name: "Return to Functions",
    description: "Learn how to return values from functions and use them in programs.",
    imagePath: "assets/functions.jpeg",
    levels: [
      Level(number: 1, problem: "Write a function that returns the sum of two integers.", expectedOutput: "7\n"), // Example for sum(3, 4)
      Level(number: 2, problem: "Write a function that returns the product of two numbers.", expectedOutput: "12\n"), // Example for product(3, 4)
      Level(number: 3, problem: "Write a function that returns the greater of two numbers.", expectedOutput: "7\n"), // Example for max(5, 7)
    ],
  ),
];
