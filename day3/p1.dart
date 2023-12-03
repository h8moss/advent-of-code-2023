import 'dart:io';

// List of digits 0 - 9
final digits = List.generate(10, (index) => index).map((e) => '$e');

String? getGridDigit(List<List<String>> grid, int x, int y) {
  if (x < 0 || y < 0) return null;
  final char = grid.elementAtOrNull(x)?.elementAtOrNull(y);
  if (!digits.contains(char)) return null;
  return char;
}

void main() async {
  File f = File('day3/input_day3.txt');
  final charGrid = (await f.readAsLines()).map((e) => e.split('')).toList();
  final List<List<int>> specialCharsCoords = [];
  // Find special chars
  for (int i = 0; i < charGrid.length; i++) {
    for (int j = 0; j < charGrid[0].length; j++) {
      final char = charGrid[i][j];
      if (char != '.' && !digits.contains(char)) {
        specialCharsCoords.add([i, j]);
      }
    }
  }
  final List<int> numbers = [];
  final List<List<int>> foundDigits = [];

  for (final specialChar in specialCharsCoords) {
    for (int xDiff = -1; xDiff < 2; xDiff++) {
      for (int yDiff = -1; yDiff < 2; yDiff++) {
        final xIndex = specialChar[0] + xDiff;
        final yIndex = specialChar[1] + yDiff;
        final digit = getGridDigit(charGrid, xIndex, yIndex);
        if (digit == null) continue;
        foundDigits.add([xIndex, yIndex]);
      }
    }
  }

  while (foundDigits.isNotEmpty) {
    final currentCoords = foundDigits.removeLast();

    List<List<int>> finalNumberCoordinates = [currentCoords];

    for (int i = -1;
        getGridDigit(charGrid, currentCoords[0], currentCoords[1] + i) != null;
        i--) {
      finalNumberCoordinates = [
        [currentCoords[0], currentCoords[1] + i],
        ...finalNumberCoordinates
      ];
    }
    for (int i = 1;
        getGridDigit(charGrid, currentCoords[0], currentCoords[1] + i) != null;
        i++) {
      finalNumberCoordinates = [
        ...finalNumberCoordinates,
        [currentCoords[0], currentCoords[1] + i],
      ];
    }

    int number = 0;

    for (final coord in finalNumberCoordinates) {
      foundDigits.removeWhere(
        (element) => element[0] == coord[0] && element[1] == coord[1],
      );

      number = 10 * number + int.parse(charGrid[coord[0]][coord[1]]);
    }

    numbers.add(number);
  }

  print(numbers.fold<int>(
      0, (previousValue, element) => previousValue + element));
}
