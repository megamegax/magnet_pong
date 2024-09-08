import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:magnet_pong/models/color_utils.dart';
import 'package:magnet_pong/models/element_type.dart';
import 'package:magnet_pong/models/player_position.dart';
part 'player.mapper.dart';

@MappableClass(includeCustomMappers: [ColorMapper(), MaterialColorMapper()])
class Player with PlayerMappable {
  final String id;
  final String name;
  final ElementType element;
  final PlayerPosition position;

  final Color color;
  final double health;
  final bool isAI;

  Player({
    required this.id,
    required this.name,
    required this.element,
    required this.position,
    required this.color,
    this.health = 100.0,
    this.isAI = false,
  });
}
