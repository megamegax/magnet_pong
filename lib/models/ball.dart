import 'dart:ui';
import 'dart:math';
import 'package:dart_mappable/dart_mappable.dart';

part 'ball.mapper.dart';

@MappableClass(includeCustomMappers: [OffsetMapper(), ColorMapper()])
class Ball with BallMappable {
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
}

class OffsetMapper extends SimpleMapper<Offset> {
  const OffsetMapper();
  @override
  Offset decode(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Offset(value['dx'], value['dy']);
    }
    throw Exception('Cannot decode Offset from $value');
  }

  @override
  dynamic encode(Offset value) {
    return {'dx': value.dx, 'dy': value.dy};
  }
}

class ColorMapper extends SimpleMapper<Color> {
  const ColorMapper();
  @override
  Color decode(dynamic value) {
    if (value is int) {
      return Color(value);
    }
    throw Exception('Cannot decode Color from $value');
  }

  @override
  dynamic encode(Color value) {
    return value.value;
  }
}
