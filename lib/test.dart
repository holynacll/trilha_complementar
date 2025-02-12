class ImmutablePoint {
  static const ImmutablePoint origin = ImmutablePoint(0, 0);

  final double x, y;

  const ImmutablePoint(this.x, this.y);
}

void main() {
  var p = const ImmutablePoint(1, 1);
  var p2 = ImmutablePoint(1, 1);
  // print("x: ${p.x} and y: ${p.y}");
  print('the type of p is ${p.runtimeType}');
  print('the type of p2 is ${p2.runtimeType}');
}
