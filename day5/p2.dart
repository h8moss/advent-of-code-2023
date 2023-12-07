import 'dart:io';

class NumberRange {
  NumberRange({
    required this.start,
    this.length = 1,
  });

  int start;
  int length;

  int get end =>
      start + length; // end is the first number not included in the range
  int get last => start + length - 1; // last is the last number included

  bool contains(int num) {
    return num >= start && num < end;
  }

  bool touchesRange(NumberRange range) {
    return range.end > start || end > range.start;
  }

  bool containsRange(NumberRange range) {
    return range.start >= start && end >= range.end;
  }

  bool isContainedBy(NumberRange range) {
    return range.containsRange(this);
  }

  @override
  String toString() {
    return '$start:$last';
  }

  @override
  operator ==(Object other) {
    if (other is NumberRange) {
      return other.start == start && other.length == length;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(start, length);
}

class RangeMap {
  RangeMap({
    required this.rangeA,
    required this.rangeB,
  });

  NumberRange rangeA;
  NumberRange rangeB;

  int aToB(int a) {
    if (!rangeA.contains(a)) return a;
    return rangeB.start + a - rangeA.start;
  }

  int bToA(int b) {
    if (!rangeB.contains(b)) return b;
    return rangeA.start + b - rangeB.start;
  }

  List<NumberRange> aRangeToB(NumberRange a) {
    if (!rangeA.containsRange(a)) return [];
    // range is contained left side and not right side
    if (a.start < rangeA.start && a.end < rangeA.end) {
      return [
        NumberRange(start: a.start, length: rangeA.start - a.start),
        NumberRange(start: rangeB.start, length: a.end - rangeA.start)
      ];
    }
    // range is contained right side and not left side
    if (a.start >= rangeA.start && a.end >= rangeA.end) {
      int difference = a.start - rangeA.start;
      int differenceEnd = rangeA.end - a.start;
      return [
        NumberRange(start: rangeB.start + difference, length: differenceEnd),
        NumberRange(
            start: a.start + differenceEnd, length: a.length - differenceEnd),
      ];
    }
    // range is contained both sides
    if (a.start >= rangeA.start && a.end < rangeA.end) {
      return [NumberRange(start: aToB(a.start), length: a.length)];
    }
    // range is not contained at all, it contains us
    if (a.start < rangeA.start && a.end >= rangeA.end) {
      return [
        NumberRange(start: a.start, length: rangeA.start - a.start),
        rangeB,
        NumberRange(start: rangeA.end, length: a.end - rangeA.end),
      ];
    }
    throw "I don't know what happened!!";
  }
}

class CategoryConverter {
  CategoryConverter({
    required this.fromCategory,
    required this.ranges,
    required this.toCategory,
  });

  String fromCategory;
  String toCategory;
  List<RangeMap> ranges;

  List<NumberRange> convert(NumberRange rangeToConvert) {
    List<NumberRange> result = [];
    ranges.sort((a, b) => a.rangeA.start - b.rangeA.start);

    for (final currentRange in ranges) {
      final compareRange = currentRange.rangeA;
      final resultRange = currentRange.rangeB;

      // if we are done with the range
      if (rangeToConvert.length <= 0) {
        break;
      }
      // if range encapsulates rangeToConvert
      if (compareRange.start <= rangeToConvert.start &&
          compareRange.end >= rangeToConvert.end) {
        result.add(NumberRange(
            start: currentRange.aToB(rangeToConvert.start),
            length: rangeToConvert.length));
        rangeToConvert.length = 0;
      }

      // if range is before rangeToConvert
      else if (compareRange.end <= rangeToConvert.start) {
        continue;
      }
      // if range is after rangeToConvert
      else if (compareRange.start >= rangeToConvert.end) {
        result.add(rangeToConvert);
        rangeToConvert.length = 0;
      }
      // if range touches the left end of rangeToConvert
      else if (compareRange.start <= rangeToConvert.start &&
          compareRange.end <= rangeToConvert.end) {
        result.add(
          NumberRange(
              start: currentRange.aToB(rangeToConvert.start),
              length: compareRange.end - rangeToConvert.start),
        );
        rangeToConvert = NumberRange(
            start: compareRange.end,
            length: rangeToConvert.end - compareRange.end);
      }
      // if range is inside rangeToConvert
      else if (compareRange.start >= rangeToConvert.start &&
          compareRange.end <= rangeToConvert.end) {
        result.addAll([
          NumberRange(
              start: rangeToConvert.start,
              length: compareRange.start - rangeToConvert.start),
          resultRange,
        ]);
        rangeToConvert = NumberRange(
            start: compareRange.end,
            length: rangeToConvert.end - compareRange.end);
      }
      // if range touches the right end of rangeToConvert
      else if (compareRange.start >= rangeToConvert.start &&
          compareRange.end >= rangeToConvert.end) {
        result.addAll([
          NumberRange(
              start: rangeToConvert.start,
              length: compareRange.start - rangeToConvert.start),
          NumberRange(
              start: resultRange.start,
              length: rangeToConvert.end - compareRange.start),
        ]);

        rangeToConvert.length = 0;
      }
    }

    if (rangeToConvert.length > 0) {
      result.add(rangeToConvert);
    }

    return result;
  }
}

void main() async {
  File f = File('day5/input_day5.txt');
  final lines = await f.readAsLines();
  final seedsString = lines.removeAt(0);
  final seedValues = seedsString
      .substring(seedsString.indexOf(':') + 1)
      .trim()
      .split(' ')
      .map((v) => int.parse(v))
      .toList();
  final List<NumberRange> seeds = [];
  for (int i = 0; i < seedValues.length; i++) {
    if (i % 2 == 0) {
      seeds.add(NumberRange(start: seedValues[i]));
    } else {
      seeds.last.length = seedValues[i];
    }
  }
  final List<CategoryConverter> converters = [];

  CategoryConverter? currentConverter = null;
  for (final line in lines) {
    if (line.length == 0) {
      if (currentConverter != null) {
        converters.add(currentConverter);
      }
      currentConverter = null;
      continue;
    }
    if (currentConverter == null && line.endsWith(' map:')) {
      final [from, to] = line.split(' ').first.split('-to-');
      currentConverter =
          CategoryConverter(fromCategory: from, toCategory: to, ranges: []);
      continue;
    }
    if (currentConverter != null) {
      final [target, initial, length] =
          line.split(' ').map((e) => int.parse(e)).toList();

      currentConverter.ranges = [
        ...currentConverter.ranges,
        RangeMap(
          rangeA: NumberRange(start: initial, length: length),
          rangeB: NumberRange(start: target, length: length),
        )
      ];
    }
  }
  if (currentConverter != null) {
    converters.add(currentConverter);
  }

  List<List<NumberRange>> newSeeds = seeds.map((e) => [e]).toList();
  for (final converter in converters) {
    print(newSeeds);
    print('${converter.fromCategory}-${converter.toCategory}');
    for (int i = 0; i < newSeeds.length; i++) {
      newSeeds[i] = newSeeds[i]
          .map((e) => converter.convert(e))
          .toList()
          .fold([], (previousValue, element) => [...previousValue, ...element]);
    }
  }
  final flatList =
      newSeeds.fold<List<NumberRange>>([], (prev, e) => [...prev, ...e]);
  flatList.sort((a, b) => a.start - b.start);

  print(flatList);
}
