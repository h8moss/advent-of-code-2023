import 'dart:convert';
import 'dart:io';

const textDigits = [
  'zero',
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
];

const textDigitsMap = {
  'z': {
    'e': {
      'r': {'o': 0}
    }
  },
  'o': {
    'n': {'e': 1}
  },
  't': {
    'w': {'o': 2},
    'h': {
      'r': {
        'e': {'e': 3}
      }
    }
  },
  'f': {
    'o': {
      'u': {'r': 4}
    },
    'i': {
      'v': {'e': 5}
    }
  },
  's': {
    'i': {'x': 6},
    'e': {
      'v': {
        'e': {'n': 7}
      }
    }
  },
  'e': {
    'i': {
      'g': {
        'h': {'t': 8}
      }
    }
  },
  'n': {
    'i': {
      'n': {'e': 9}
    }
  }
};

const reverseTextDigitsMap = {
  'o': {
    'r': {
      'e': {'z': 0}
    },
    'w': {'t': 2}
  },
  'e': {
    'n': {
      'o': 1,
      'i': {'n': 9}
    },
    'e': {
      'r': {
        'h': {'t': 3}
      }
    },
    'v': {
      'i': {'f': 5}
    }
  },
  'r': {
    'u': {
      'o': {'f': 4}
    }
  },
  'x': {
    'i': {'s': 6}
  },
  'n': {
    'e': {
      'v': {
        'e': {'s': 7}
      }
    }
  },
  't': {
    'h': {
      'g': {
        'i': {'e': 8}
      }
    }
  },
};

int? findFirstDigit(String str,
    {Map<String, dynamic> currentMap = textDigitsMap,
    bool isRecursed = false}) {
  if (str.length == 0) return null;
  final firstChar = str[0];
  final parsed = int.tryParse(firstChar);

  if (parsed != null) return parsed;

  if (currentMap.containsKey(firstChar)) {
    if (currentMap[firstChar] is int) return currentMap[firstChar];
    final res = findFirstDigit(str.substring(1),
        currentMap: currentMap[firstChar], isRecursed: true);
    if (res != null) return res;
  }
  if (isRecursed) {
    return null;
  }
  return findFirstDigit(str.substring(1), isRecursed: isRecursed);
}

int? findLastDigit(String str,
    {Map<String, dynamic> currentMap = reverseTextDigitsMap,
    bool isRecursed = false}) {
  if (str.length == 0) return null;
  final lastChar = str[str.length - 1];
  final parsed = int.tryParse(lastChar);

  if (parsed != null) return parsed;

  if (currentMap.containsKey(lastChar)) {
    if (currentMap[lastChar] is int) return currentMap[lastChar];
    final res = findLastDigit(str.substring(0, str.length - 1),
        currentMap: currentMap[lastChar], isRecursed: true);
    if (res != null) return res;
  }
  if (isRecursed) {
    return null;
  }

  return findLastDigit(str.substring(0, str.length - 1),
      isRecursed: isRecursed);
}

void main() async {
  File f = File('./day1/input_day1.txt');
  final lines = await f.readAsLines();
  List<int> codes = [];
  for (final line in lines) {
    final lastDigit = findLastDigit(line) ?? 0;
    final firstDigit = findFirstDigit(line) ?? 0;
    print(line + ' (${firstDigit * 10 + lastDigit})');
    codes.add(firstDigit * 10 + lastDigit);
  }

  int result = codes.reduce((value, element) => value + element);

  print('result: $result');
}
