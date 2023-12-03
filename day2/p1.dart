import 'dart:io';

class ColorCount {
  ColorCount({this.red = 0, this.blue = 0, this.green = 0});

  int red;
  int green;
  int blue;

  void setString(String color, int value) {
    switch (color) {
      case 'red':
        red = value;
        break;
      case 'green':
        green = value;
        break;
      case 'blue':
        blue = value;
        break;
    }
  }

  @override
  String toString() {
    return '($red, $green, $blue)';
  }
}

List<ColorCount> stringToColorMap(String val) {
  val = val.substring(val.indexOf(':') + 1).trim();
  final list = val.split(';').map((v) => v.trim()).toList();
  return list.map((round) {
    final colors = round.split(',').map((v) => v.trim());
    ColorCount counter = ColorCount();
    for (final colorCount in colors) {
      final [count, color] = colorCount.split(' ');
      counter.setString(color, int.parse(count));
    }
    return counter;
  }).toList();
}

void main() async {
  const rLimit = 12;
  const gLimit = 13;
  const bLimit = 14;

  File f = File('./day2/input_day2.txt');
  final games = await f.readAsLines();
  var gameMaxColorCount = games
      .map(
        (e) => stringToColorMap(e),
      )
      .map(
        (e) => e.fold(
          ColorCount(),
          (previousValue, element) {
            if (previousValue.red < element.red)
              previousValue.red = element.red;
            if (previousValue.green < element.green)
              previousValue.green = element.green;
            if (previousValue.blue < element.blue)
              previousValue.blue = element.blue;
            return previousValue;
          },
        ),
      )
      .toList()
      .asMap();

  print(gameMaxColorCount.keys
      .where((i) =>
          gameMaxColorCount[i]!.red <= rLimit &&
          gameMaxColorCount[i]!.green <= gLimit &&
          gameMaxColorCount[i]!.blue <= bLimit)
      .fold<int>(0, (previousValue, element) => previousValue + element + 1));
}
