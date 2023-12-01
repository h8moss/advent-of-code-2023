import 'dart:io';

int findFirstDigit(String str) {
  for (int i = 0; i < str.length; i++) {
    String c = str[i];
    int? parsed = int.tryParse(c);
    if (parsed != null) return parsed;
  }
  return 0;
}

int findLastDigit(String str) {
  for (int i = str.length - 1; i >= 0; i--) {
    String c = str[i];
    int? parsed = int.tryParse(c);
    if (parsed != null) return parsed;
  }
  return 0;
}

void main() async {
  File f = File('./input_day1.txt');
  final lines = await f.readAsLines();
  List<int> codes = [];
  for (final line in lines) {
    final lastDigit = findLastDigit(line);
    final firstDigit = findFirstDigit(line);
    codes.add(firstDigit * 10 + lastDigit);
  }

  int result = codes.reduce((value, element) => value + element);

  print('result: $result');
}
