import 'dart:math';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:magnet_pong/models/player.dart';
part 'paddle.mapper.dart';

@MappableClass()
class Paddle with PaddleMappable {
  Offset position;
  final double width;
  final double height;
  double charge;
  Offset movementDelta; // Tároljuk a paddle mozgásának irányát és sebességét
  final Player
      player; // Hozzáadott Player objektum a játékos információinak tárolására

  Paddle({
    required this.position,
    required this.width,
    required this.height,
    required this.player, // Player kötelezővé tétele
    this.charge = 0,
    this.movementDelta = Offset.zero,
  });

  Rect get rect {
    final double thickness = charge / 10 + 10;
    if (width > height) {
      return Rect.fromLTWH(
        position.dx - width / 2,
        position.dy - thickness / 2,
        width,
        thickness,
      );
    } else {
      return Rect.fromLTWH(
        position.dx - thickness / 2,
        position.dy - height / 2,
        thickness,
        height,
      );
    }
  }

  void move(double delta) {
    movementDelta = Offset(delta, 0); // Mozgás tárolása
    position = Offset(position.dx + delta, position.dy);
  }

  void moveVertical(double delta) {
    movementDelta = Offset(0, delta); // Mozgás tárolása
    position = Offset(position.dx, position.dy + delta);
  }

  Paddle updateCharge(double amount) {
    final double newCharge = min(charge + amount, 100);
    return copyWith(charge: newCharge);
  }

  Paddle resetCharge() {
    return copyWith(charge: 0);
  }

  bool canShoot() {
    return charge >= 1; // Legalább 10-es töltöttség szükséges a lövéshez
  }

}
