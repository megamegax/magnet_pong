import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:magnet_pong/models/player_position.dart';

import '../models/paddle.dart';
import '../models/ball.dart';
import '../models/player.dart';
import '../models/gravity_rule.dart';
part 'game_state.mapper.dart';

@MappableClass(includeCustomMappers: [SizeMapper()])
class GameState with GameStateMappable {
  final Map<PlayerPosition, Paddle> paddles;
  final Map<PlayerPosition, double> lives;

  final List<Ball> balls;
  final Player currentPlayer;
  final List<Player> activePlayers;
  final double rotationX; // Új mező a X tengely menti forgatáshoz
  final double rotationY; // Új mező a Y tengely menti forgatáshoz
  final GravityRule gravityRule;
  final Size fieldSize;
  final bool isGameOver; // Új mező a játék véget érésének kezelésére
  final String? winnerName; // A győztes nevét tárolja

  GameState({
    required this.paddles,
    required this.balls,
    required this.currentPlayer,
    required this.activePlayers,
    required this.rotationX,
    required this.rotationY,
    required this.gravityRule,
    required this.fieldSize,
    required this.lives,
    this.isGameOver = false,
    this.winnerName,
  });

  factory GameState.initial(List<Player> activePlayers, Player currentPlayer,
      GravityRule gravityRule) {
    final initialLives = {
      for (var player in activePlayers) player.position: 100.0
    };

    return GameState(
        paddles: {
          if (activePlayers.isNotEmpty)
            PlayerPosition.left: Paddle(
                position: const Offset(10, 200),
                width: 20,
                height: 100,
                player: activePlayers[0]),
          if (activePlayers.length > 1)
            PlayerPosition.right: Paddle(
                position: const Offset(680, 200),
                width: 20,
                height: 100,
                player: activePlayers[1]),
          if (activePlayers.length > 2)
            PlayerPosition.top: Paddle(
                position: const Offset(200, 10),
                width: 100,
                height: 20,
                player: activePlayers[2]),
          if (activePlayers.length > 3)
            PlayerPosition.bottom: Paddle(
                position: const Offset(200, 380),
                width: 100,
                height: 20,
                player: activePlayers[3]),
        },
        balls: [],
        currentPlayer: currentPlayer,
        activePlayers: activePlayers,
        rotationX: 0.0,
        rotationY: 0.0,
        gravityRule: gravityRule,
        fieldSize: Size.zero,
        lives: initialLives);
  }
}

class SizeMapper extends SimpleMapper<Size> {
  const SizeMapper();

  @override
  Size decode(dynamic value) {
    return Size(value['width'], value['height']);
  }

  @override
  dynamic encode(Size self) {
    return {'width': self.width, 'height': self.height};
  }
}
