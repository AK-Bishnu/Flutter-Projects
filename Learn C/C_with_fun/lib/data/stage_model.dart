class Level {
  final int number;
  final String problem;
  final String expectedOutput;

  Level({required this.number, required this.problem, required this.expectedOutput});
}

class Stage {
  final int stageNumber;
  final String name;
  final String description;
  final String imagePath;
  final List<Level> levels;

  Stage({
    required this.stageNumber,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.levels,
  });
}
