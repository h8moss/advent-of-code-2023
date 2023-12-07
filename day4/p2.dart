import 'dart:io';

void main() async {
  final f = File('day4/input_day4.txt');
  final cards = await f.readAsLines();
  List<int> cardCounter = List.filled(cards.length, 1);
  for (int i = 0; i < cards.length; i++) {
    String card = cards[i]
        .substring(cards[i].indexOf(':') + 1)
        .trim(); // remove card number
    final [currentNumbers, winningNumbers] = card
        .split('|')
        .map((e) => e
            .split(' ')
            .where((e) => int.tryParse(e) != null)
            .map((e) => int.parse(e)))
        .toList();
    int points = currentNumbers
        .where((element) => winningNumbers.contains(element))
        .length;
    int count = cardCounter[i];
    for (int j = i + 1; j < i + points + 1 && j < cards.length; j++) {
      cardCounter[j] += count;
    }
  }

  print(cardCounter.fold<int>(0, (prev, e) => prev + e));
}
