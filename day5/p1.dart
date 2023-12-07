import 'dart:io';

class MapRange {
  const MapRange({
    required this.initial,
    required this.target,
    required this.length,
  });

  final int initial;
  final int target;
  final int length;
}

class SeedMap {
  const SeedMap({
    required this.ranges,
    required this.from,
    required this.to,
  });

  final List<MapRange> ranges;

  final String from;
  final String to;

  int convertNumber(int source) {
    final range = ranges
        .where((element) =>
            element.initial <= source &&
            element.initial + element.length > source)
        .toList();
    if (range.isEmpty) return source;
    return range[0].target + source - range[0].initial;
  }
}

int convertToLocation(List<SeedMap> seedMaps, int source, String category) {
  if (category == 'location') return source;
  final map = seedMaps.firstWhere((element) => element.from == category);
  final result = map.convertNumber(source);
  return convertToLocation(seedMaps, result, map.to);
}

void main() async {
  File f = File('day5/input_day5.txt');
  final lines = await f.readAsLines();
  final seedsString = lines.removeAt(0);
  final seeds = seedsString
      .substring(seedsString.indexOf(':') + 1)
      .trim()
      .split(' ')
      .map((v) => int.parse(v));
  final List<SeedMap> seedMaps = [];

  SeedMap? currentMap = null;
  for (final line in lines) {
    if (line.length == 0) {
      if (currentMap != null) {
        seedMaps.add(currentMap);
      }
      currentMap = null;
      continue;
    }
    if (currentMap == null && line.endsWith(' map:')) {
      final [from, to] = line.split(' ').first.split('-to-');
      currentMap = SeedMap(from: from, to: to, ranges: []);
      continue;
    }
    if (currentMap != null) {
      final [target, initial, length] =
          line.split(' ').map((e) => int.parse(e)).toList();

      currentMap.ranges.add(MapRange(
        initial: initial,
        target: target,
        length: length,
      ));
    }
  }
  if (currentMap != null) {
    seedMaps.add(currentMap);
  }

  print(seeds.map((e) => convertToLocation(seedMaps, e, 'seed')).fold<int?>(
      null,
      (previousValue, element) => previousValue == null
          ? element
          : (previousValue < element ? previousValue : element)));
}
