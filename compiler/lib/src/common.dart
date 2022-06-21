import 'dart:math' as math;

T sample<T>(Iterable<T> samples, math.Random rand) {
  final List<T> list = samples.toList();
  final int idx = rand.nextInt(list.length);
  return list[idx];
}
