import 'dart:async';
import 'dart:math';
import 'package:gravity_pong/models/ball.dart';
import 'package:gravity_pong/models/paddle.dart';
import 'package:gravity_pong/state/game_state.dart';

import '../models/player.dart';
import '../models/element_type.dart';
import '../models/player_position.dart';

class AIPlayer extends Player {
  AIPlayer({required Player player})
      : super(
            id: player.id,
            name: player.name,
            element: player.element,
            position: player.position,
            color: player.color,
            health: player.health,
            isAI: true);

  Timer? _controlTimer;
  double _paddleCharge = 0;

  void startPlaying(
      GameState state,
      Function(Player player, double delta) movePaddle,
      Function(Player player) shootBall) {
    _controlTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _paddleCharge += 0.1;

      final ball = _findIncomingBall(state);
      if (ball != null) {
        _movePaddleToInterceptBall(state, ball, movePaddle);
      }

      // Ellenőrizzük, hogy a meglévő golyók túlságosan közel vannak-e a paddle-hez
      final shouldShoot = !_isAnyBallTooClose(state);

      if (_paddleCharge >= 50 && shouldShoot) {
        shootBall(this);
        _paddleCharge = 0;
      }
    });
  }

  void _movePaddleToInterceptBall(GameState state, Ball ball,
      Function(Player player, double delta) movePaddle) {
    final paddle = state.paddles[position]!;

    if (position == PlayerPosition.top || position == PlayerPosition.bottom) {
      if (ball.position.dx < paddle.position.dx) {
        movePaddle(this, -2);
      } else if (ball.position.dx > paddle.position.dx) {
        movePaddle(this, 2);
      }
    } else {
      if (ball.position.dy < paddle.position.dy) {
        movePaddle(this, -2);
      } else if (ball.position.dy > paddle.position.dy) {
        movePaddle(this, 2);
      }
    }
  }

  Ball? _findIncomingBall(GameState state) {
    final paddle = state.paddles[position]!;
    Ball? closestBall;
    double closestDistance = double.infinity;

    for (final ball in state.balls) {
      if (_isBallHeadingTowardsPaddle(ball, paddle)) {
        final distance = (ball.position - paddle.position).distance;
        if (distance < closestDistance) {
          closestBall = ball;
          closestDistance = distance;
        }
      }
    }

    return closestBall;
  }

  bool _isBallHeadingTowardsPaddle(Ball ball, Paddle paddle) {
    if (position == PlayerPosition.top) {
      return ball.velocity.dy > 0;
    } else if (position == PlayerPosition.bottom) {
      return ball.velocity.dy < 0;
    } else if (position == PlayerPosition.left) {
      return ball.velocity.dx < 0;
    } else if (position == PlayerPosition.right) {
      return ball.velocity.dx > 0;
    }
    return false;
  }

  bool _isAnyBallTooClose(GameState state) {
    final paddle = state.paddles[position]!;
    const double closeDistanceThreshold = 50.0; // Közelség küszöbértéke

    for (final ball in state.balls) {
      final distance = (ball.position - paddle.position).distance;

      if (distance < closeDistanceThreshold &&
          _isBallHeadingTowardsPaddle(ball, paddle)) {
        return true;
      }
    }
    return false;
  }

  void stopPlaying() {
    _controlTimer?.cancel();
  }
}
