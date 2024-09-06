import 'dart:ui';

import 'package:gravity_pong/models/element_type.dart';
import 'package:gravity_pong/models/player_position.dart';

class Player {
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'element': element.index,
      'position': position.index,
      'color': color.value,
      'health': health,
      'isAI': isAI,
    };
  }

  Player copyWith({
    String? id,
    String? name,
    ElementType? element,
    PlayerPosition? position,
    Color? color,
    double? health,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      element: element ?? this.element,
      position: position ?? this.position,
      color: color ?? this.color,
      health: health ?? this.health,
    );
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      element: ElementType.values[map['element']],
      position: PlayerPosition.values[map['position']],
      color: Color(map['color']),
      health: map['health'] ?? 100.0,
      isAI: map['isAI'] ?? false,
    );
  }
}
