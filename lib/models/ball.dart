import 'dart:ui';
import 'dart:math';

class Ball {
  final Offset position;
  final Offset velocity;
  final double mass;
  final Color color;

  Ball({
    required this.position,
    required this.velocity,
    required this.mass,
    required this.color,
  });

  // Radius kiszámítása a mass alapján
  double get radius {
    // Példa: a radius a mass négyzetgyökén alapul
    return sqrt(mass);
  }

  Ball copyWith({
    Offset? position,
    Offset? velocity,
    double? mass,
    Color? color,
  }) {
    return Ball(
      position: position ?? this.position,
      velocity: velocity ?? this.velocity,
      mass: mass ?? this.mass,
      color: color ?? this.color,
    );
  }
}
