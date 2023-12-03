import 'dart:io';

// List of digits 0 - 9
final digits = List.generate(10, (index) => index).map((e) => '$e');

String? getGridDigit(List<List<String>> grid, int x, int y) {
  if (x < 0 || y < 0) return null;
  final char = grid.elementAtOrNull(x)?.elementAtOrNull(y);
  if (!digits.contains(char)) return null;
  return char;
}

bool isDigit(List<List<String>> grid, int x, int y) {
  return getGridDigit(grid, x, y) != null;
}

void main() async {
  File f = File('day3/input_day3.txt');
  final charGrid = (await f.readAsLines()).map((e) => e.split('')).toList();
  List<int> valuesList = [];

  for (int i = 0; i < charGrid.length; i++) {
    bool isInNum = false;
    for (int j = 0; j < charGrid[i].length; j++) {
      if (isDigit(charGrid, i, j)) {
        if (isInNum) {
          valuesList[valuesList.length - 1] =
              valuesList[valuesList.length - 1] * 10 +
                  int.parse(charGrid[i][j]);
        } else {
          isInNum = true;
          valuesList.add(int.parse(charGrid[i][j]));
        }
        charGrid[i][j] = (valuesList.length - 1).toString();
      } else {
        isInNum = false;
      }
    }
  }

  final List<List<int>> gearCoords = [];
  // Find gears
  for (int i = 0; i < charGrid.length; i++) {
    for (int j = 0; j < charGrid[0].length; j++) {
      final char = charGrid[i][j];
      if (char == '*') {
        gearCoords.add([i, j]);
      }
    }
  }

  int result = 0;
  for (final coord in gearCoords) {
    List<int> digits = [];
    for (int x = -1; x < 2; x++) {
      for (int y = -1; y < 2; y++) {
        final neighbour = [coord[0] + x, coord[1] + y];
        final num = int.tryParse(charGrid[neighbour[0]][neighbour[1]]);
        if (num != null) {
          digits.add(num);
        }
      }
    }
    digits = digits.toSet().toList();
    if (digits.length == 2) {
      result += valuesList[digits[0]] * valuesList[digits[1]];
    }
  }

  print(result);
}
