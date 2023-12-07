import 'dart:io';

void main() async {
  final f = File('day4/input_day4.txt');
  final cards = await f.readAsLines();
  int totalValue = 0;
  for (String card in cards) {
    card = card.substring(card.indexOf(':') + 1).trim(); // remove card number
    final [currentNumbers, winningNumbers] = card
        .split('|')
        .map((e) => e
            .split(' ')
            .where((e) => int.tryParse(e) != null)
            .map((e) => int.parse(e)))
        .toList();
    int points = 0;
    for (final num in currentNumbers) {
      if (winningNumbers.contains(num)) {
        if (points == 0)
          points = 1;
        else
          points = points * 2;
      }
    }
    totalValue += points;
  }

  print(totalValue);
}
