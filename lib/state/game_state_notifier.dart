import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magnet_pong/ai/ai_player.dart';
import '../models/ball.dart';
import '../models/element_type.dart';
import '../models/gravity_rule.dart';
import '../models/paddle.dart';
import '../models/player.dart';
import '../models/player_position.dart';
import 'game_state.dart';
import 'game_state_args.dart';

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier(
      List<Player> activePlayers, Player currentPlayer, GravityRule gravityRule)
      : super(GameState.initial(activePlayers, currentPlayer, gravityRule)) {
    _startFieldRotationUpdate();
    _startChargeUpdate();
    _startBallUpdate();
    for (var player in activePlayers) {
      if (player.isAI) {
        AIPlayer aiPlayer = AIPlayer(player: player);
        startAIPlayer(aiPlayer);
        aiPlayers.add(aiPlayer);
      }
    }
  }
  List<AIPlayer> aiPlayers = [];
  Timer? _aiTimer;
  Timer? _fieldRotationTimer;
  Timer? _chargeTimer;
  Timer? _ballUpdateTimer;

  void _startChargeUpdate() {
    _chargeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final newPaddles = {
        for (var entry in state.paddles.entries)
          entry.key: entry.value.updateCharge(0.5)
      };
      state = state.copyWith(paddles: newPaddles);
    });
  }

  void _startFieldRotationUpdate() {
    _fieldRotationTimer =
        Timer.periodic(const Duration(milliseconds: 64), (timer) {
      if (state.balls.isEmpty) {
        state = state.copyWith(
          rotationX: 0.0,
          rotationY: 0.0,
        );
        return;
      }
      final double centerX = state.fieldSize.width / 2;
      final double centerY = state.fieldSize.height / 2;

      double weightedSumX = 0.0;
      double weightedSumY = 0.0;
      double totalWeight = 0.0;

      for (final ball in state.balls) {
        weightedSumX += (ball.position.dx - centerX) * ball.mass;
        weightedSumY += (ball.position.dy - centerY) * ball.mass;
        totalWeight += ball.mass;
      }

      const double maxRotation = 0.5; // Forgatás maximális értéke
      final double rotationX =
          (weightedSumY / totalWeight) * maxRotation / centerY;
      final double rotationY =
          (weightedSumX / totalWeight) * maxRotation / centerX;

      // Állapot frissítése a copyWith metódussal
      state = state.copyWith(
        rotationX: rotationX.clamp(-maxRotation, maxRotation),
        rotationY: rotationY.clamp(-maxRotation, maxRotation),
      );
    });
  }

  void _startBallUpdate() {
    _ballUpdateTimer =
        Timer.periodic(const Duration(milliseconds: 16), (timer) {
      updateBallPositions();
    });
  }

  @override
  void dispose() {
    _fieldRotationTimer?.cancel();
    _chargeTimer?.cancel();
    _ballUpdateTimer?.cancel();
    stopAIPlayer();
    super.dispose();
  }

  void updateBallPositions() {
    const double gravityConstant = 10.0; // Gravitációs erő
    const double maxSpeed = 5.0; // Maximális sebesség korlátozás

    List<Ball> newBalls = [];
    Map<PlayerPosition, double> updatedLives = {
      ...state.lives
    }; // Életek másolása

    for (var ballA in state.balls) {
      Offset newPosition = ballA.position;
      Offset newVelocity = ballA.velocity;

      // 1. Falakkal való ütközés kezelése
      final collisionResult = _handleWallCollision(
          ballA, ballA.position + newVelocity, state.fieldSize);
      newVelocity = collisionResult["velocity"]!;
      newPosition = collisionResult["position"]!;

      // Ha a fal érintése egy játékos falán történik, az élet csökkentése és a golyó eltávolítása
      // Ha a fal érintése egy játékos falán történik, az élet csökkentése és a golyó eltávolítása
      if (collisionResult["isPlayerWallHit"] == true) {
        PlayerPosition hitPlayer = collisionResult["playerPosition"]!;

        // Csak akkor csökkentsük az életet, ha a játékos valóban létezik
        if (updatedLives.containsKey(hitPlayer)) {
          updatedLives[hitPlayer] = updatedLives[hitPlayer]! - ballA.mass / 2;

          if (updatedLives[hitPlayer]! <= 0) {
            _checkForWinner(); // Ha elfogyott az élete, ellenőrizzük a győztest
          }
        }

        continue; // Golyó megsemmisítése
      }

      // 2. Paddle ütközés
      newVelocity =
          _handlePaddleCollision(ballA, newVelocity, newPosition: newPosition);

      // 3. Gravitációs erő kiszámítása és alkalmazása
      final totalForce =
          calculateTotalForce(ballA, state.balls, gravityConstant);
      Offset acceleration =
          totalForce / ballA.mass; // Force/Mass -> Acceleration
      newVelocity += acceleration;

      // Korlátozzuk a sebességet
      if (newVelocity.distance > maxSpeed) {
        newVelocity = newVelocity / newVelocity.distance * maxSpeed;
      }

      // Frissítjük a pozíciót a sebesség alapján
      newPosition += newVelocity;

      // Új labda létrehozása a módosított pozícióval és sebességgel
      Ball updatedBall = ballA.copyWith(
        position: newPosition,
        velocity: newVelocity,
      );

      // Hozzáadjuk az új labdát a listához
      newBalls.add(updatedBall);
    }

    // Ellenőrizd és kezeld az összeolvadásokat
    newBalls = checkAndHandleBallCollisions(newBalls);
    // Állapot frissítése a módosított labdákkal és életekkel
    state = state.copyWith(balls: newBalls, lives: updatedLives);
  }

  double calculateScaleFactor(double rotationX, double rotationY) {
    // Egyszerű példa egy skálázási tényezőre a dőlés alapján
    // A skálázás arányosan változik a forgatás mértékével
    return 1.0 + 0.1 * (rotationX.abs() + rotationY.abs());
  }

  Color getWallColor(PlayerPosition playerPosition) {
    // Ellenőrizzük, hogy az adott fal egy játékos veszélyzónája-e
    if (state.paddles.containsKey(playerPosition)) {
      return state
          .paddles[playerPosition]!.player.color; // Veszélyzóna: játékos színe
    }
    return Colors.grey; // Visszaverődő fal: szürke szín
  }

  Offset calculateTotalForce(
      Ball ballA, List<Ball> balls, double gravityConstant) {
    Offset totalForce = Offset.zero;
    const double minDistance =
        20.0; // Minimális távolság a túl nagy erők elkerülése érdekében

    for (var ballB in balls) {
      if (ballA != ballB) {
        final direction = ballB.position - ballA.position;
        double distance = direction.distance;

        if (distance < minDistance) {
          distance = minDistance; // Távolság korlátozása
        }

        // Azonos színű labdák taszítása vagy vonzása a gravityRule alapján
        final bool sameColor = ballA.color == ballB.color;
        final double forceMagnitude =
            gravityConstant * (ballA.mass * ballB.mass) / (distance * distance);

        // Azonos szín esetén a szabály szerint taszítás vagy vonzás
        double adjustedForceMagnitude;
        if (sameColor) {
          if (state.gravityRule == GravityRule.repelSameColor) {
            adjustedForceMagnitude = -forceMagnitude; // Taszítás
          } else {
            adjustedForceMagnitude = forceMagnitude; // Vonzás
          }
        } else {
          adjustedForceMagnitude =
              forceMagnitude; // Különböző színek: alapértelmezett vonzás
        }

        final forceDirection = direction / distance;
        final force = forceDirection * adjustedForceMagnitude;
        totalForce += force;
      }
    }

    return totalForce;
  }

  Offset _handlePaddleCollision(Ball ball, Offset currentVelocity,
      {required Offset newPosition}) {
    Paddle? collidingPaddle;

    // Ellenőrizzük, hogy melyik paddle ütközhet a labdával
    state.paddles.forEach((position, paddle) {
      if (paddle.rect.overlaps(
          Rect.fromCircle(center: newPosition, radius: ball.radius))) {
        collidingPaddle = paddle;
      }
    });

    if (collidingPaddle != null) {
      // Megállapítjuk, hogy a paddle melyik pontján történt az ütközés
      final double paddleCenterX = collidingPaddle!.rect.center.dx;
      final double paddleCenterY = collidingPaddle!.rect.center.dy;

      // Számítsuk ki az elütési arányt, de csak a szélek felé görbüljön
      final double hitX =
          (newPosition.dx - paddleCenterX) / (collidingPaddle!.width / 2);
      final double hitY =
          (newPosition.dy - paddleCenterY) / (collidingPaddle!.height / 2);

      // Csak a szélekhez közeli ütések számítanak (20% széles sávok a széleken)
      const double curveThreshold = 0.9;
      double curveFactorX = hitX.abs() > curveThreshold ? hitX : 0;
      double curveFactorY = hitY.abs() > curveThreshold ? hitY : 0;

      Offset newVelocity;
      if (collidingPaddle!.width > collidingPaddle!.height) {
        // Ha a paddle vízszintes, függőleges visszapattanás, X irányú eltéréssel
        newVelocity =
            Offset(currentVelocity.dx + curveFactorX * 5, -currentVelocity.dy);
        newPosition = Offset(
            newPosition.dx,
            collidingPaddle!.rect.top -
                ball.radius); // Labda pozíciójának korrigálása
      } else {
        // Ha a paddle függőleges, vízszintes visszapattanás, Y irányú eltéréssel
        newVelocity =
            Offset(-currentVelocity.dx, currentVelocity.dy + curveFactorY * 5);
        newPosition = Offset(collidingPaddle!.rect.left - ball.radius,
            newPosition.dy); // Labda pozíciójának korrigálása
      }

      // Normalizáljuk a sebességet, hogy ne legyen túl gyors
      const double maxSpeed = 20.0;
      if (newVelocity.distance > maxSpeed) {
        newVelocity = newVelocity / newVelocity.distance * maxSpeed;
      }

      return newVelocity;
    }

    return currentVelocity;
  }

  Offset normalize(Offset vector) {
    final double length = vector.distance;
    if (length == 0) {
      return Offset.zero;
    }
    return vector / length;
  }

  Map<String, dynamic> _handleWallCollision(
      Ball ball, Offset newPosition, Size fieldSize) {
    double velocityX = ball.velocity.dx;
    double velocityY = ball.velocity.dy;

    bool hasCollided = false;
    bool isPlayerWallHit = false;
    PlayerPosition? playerPosition;

    final double dangerZoneWidth =
        fieldSize.shortestSide / 1.5; // Veszélyzóna szélessége
    final double dangerZoneHeight =
        fieldSize.shortestSide / 1.5; // Veszélyzóna magassága

    // Ellenőrzés, hogy a labda ütközik-e a falakkal
    if (newPosition.dx - ball.radius <= 0) {
      hasCollided = true;
      // Bal oldali veszélyzóna
      if (newPosition.dy >= (fieldSize.height - dangerZoneHeight) / 2 &&
          newPosition.dy <= (fieldSize.height + dangerZoneHeight) / 2) {
        if (state.paddles.containsKey(PlayerPosition.left)) {
          isPlayerWallHit = true;
          playerPosition = PlayerPosition.left;
        }
      } else {
        velocityX = -velocityX; // Visszapattanás
      }
      newPosition = Offset(ball.radius, newPosition.dy);
    } else if (newPosition.dx + ball.radius >= fieldSize.width) {
      hasCollided = true;
      // Jobb oldali veszélyzóna
      if (newPosition.dy >= (fieldSize.height - dangerZoneHeight) / 2 &&
          newPosition.dy <= (fieldSize.height + dangerZoneHeight) / 2) {
        if (state.paddles.containsKey(PlayerPosition.right)) {
          isPlayerWallHit = true;
          playerPosition = PlayerPosition.right;
        }
      } else {
        velocityX = -velocityX; // Visszapattanás
      }
      newPosition = Offset(fieldSize.width - ball.radius, newPosition.dy);
    }

    if (newPosition.dy - ball.radius <= 0) {
      hasCollided = true;
      // Felső veszélyzóna
      if (newPosition.dx >= (fieldSize.width - dangerZoneWidth) / 2 &&
          newPosition.dx <= (fieldSize.width + dangerZoneWidth) / 2) {
        if (state.paddles.containsKey(PlayerPosition.top)) {
          isPlayerWallHit = true;
          playerPosition = PlayerPosition.top;
        }
      } else {
        velocityY = -velocityY; // Visszapattanás
      }
      newPosition = Offset(newPosition.dx, ball.radius);
    } else if (newPosition.dy + ball.radius >= fieldSize.height) {
      hasCollided = true;
      // Alsó veszélyzóna
      if (newPosition.dx >= (fieldSize.width - dangerZoneWidth) / 2 &&
          newPosition.dx <= (fieldSize.width + dangerZoneWidth) / 2) {
        if (state.paddles.containsKey(PlayerPosition.bottom)) {
          isPlayerWallHit = true;
          playerPosition = PlayerPosition.bottom;
        }
      } else {
        velocityY = -velocityY; // Visszapattanás
      }
      newPosition = Offset(newPosition.dx, fieldSize.height - ball.radius);
    }

    // Ha nincs ütközés, akkor visszaadjuk az eredeti sebességet és pozíciót
    if (!hasCollided) {
      return {
        "velocity": ball.velocity,
        "position": newPosition,
        "isPlayerWallHit": false,
      };
    }

    // Ha ütközés történt, akkor visszaadjuk az új sebességet, a frissített pozíciót és a játékos találat státuszát
    return {
      "velocity": Offset(velocityX, velocityY),
      "position": newPosition,
      "isPlayerWallHit": isPlayerWallHit,
      "playerPosition": playerPosition,
    };
  }

  List<Ball> checkAndHandleBallCollisions(List balls) {
    final List<Ball> updatedBalls = [];
    final Set mergedIndexes =
        {}; // Nyilván tartjuk az összeolvadt labdák indexeit
    for (int i = 0; i < balls.length; i++) {
      if (mergedIndexes.contains(i)) continue; // Ha már összeolvadt, átugorjuk

      Ball ballA = balls[i];
      bool merged = false;

      for (int j = i + 1; j < balls.length; j++) {
        if (mergedIndexes.contains(j)) {
          continue; // Ha már összeolvadt, átugorjuk
        }

        Ball ballB = balls[j];

        // Ellenőrizzük, hogy ütköznek-e
        if ((ballA.position - ballB.position).distance <
            ballA.radius + ballB.radius) {
          // Labdák összeolvadása
          double newMass = ballA.mass + ballB.mass;
          Offset newPosition =
              (ballA.position * ballA.mass + ballB.position * ballB.mass) /
                  newMass;
          Offset newVelocity =
              (ballA.velocity * ballA.mass + ballB.velocity * ballB.mass) /
                  newMass;

          Ball mergedBall = Ball(
            position: newPosition,
            velocity: newVelocity,
            mass: min(newMass, 100),
            color: ballA.color, // Vagy keverjük a színeket
          );

          updatedBalls.add(mergedBall);
          mergedIndexes.add(i); // Megjelöljük az összeolvadt labdákat
          mergedIndexes.add(j);
          merged = true;
          break;
        }
      }

      if (!merged) {
        updatedBalls.add(ballA); // Csak akkor adjuk hozzá, ha nem olvadt össze
      }
    }

    return updatedBalls;
  }

  void movePaddle(Player player, double delta) {
    final newPaddles = {...state.paddles};
    final paddle = newPaddles[player.position]!;

    if (player.position == PlayerPosition.left ||
        player.position == PlayerPosition.right) {
      // Függőleges mozgás, korlátozva a pálya határai között
      final newY = (paddle.position.dy + delta).clamp(
        paddle.height / 2,
        state.fieldSize.height - paddle.height / 2,
      );
      newPaddles[player.position] =
          paddle.copyWith(position: Offset(paddle.position.dx, newY));
    } else {
      // Vízszintes mozgás, korlátozva a pálya határai között
      final newX = (paddle.position.dx + delta).clamp(
        paddle.width / 2,
        state.fieldSize.width - paddle.width / 2,
      );
      newPaddles[player.position] =
          paddle.copyWith(position: Offset(newX, paddle.position.dy));
    }

    state = state.copyWith(paddles: newPaddles);
  }

  void shootBall(Player player) {
    final newPaddles = {...state.paddles};
    final paddle = newPaddles[player.position]!;
    if (paddle.canShoot()) {
      final newBalls = [...state.balls];
      Offset velocity;
      Offset spawnPosition;

      switch (player.position) {
        case PlayerPosition.top:
          velocity = const Offset(0, 5); // Lefelé
          spawnPosition = paddle.rect.center +
              Offset(0, paddle.rect.height / 2 + 10); // A paddle alatt
          break;
        case PlayerPosition.bottom:
          velocity = const Offset(0, -5); // Felfelé
          spawnPosition = paddle.rect.center -
              Offset(0, paddle.rect.height / 2 + 10); // A paddle felett
          break;
        case PlayerPosition.left:
          velocity = const Offset(5, 0.1); // Jobbra
          spawnPosition = paddle.rect.center +
              Offset(paddle.rect.width / 2 + 15, 0); // A paddle jobb oldalán
          break;
        case PlayerPosition.right:
          velocity = const Offset(-5, 0.1); // Balra
          spawnPosition = paddle.rect.center -
              Offset(paddle.rect.width / 2 + 15, 0); // A paddle bal oldalán
          break;
      }

      final ball = Ball(
        position: spawnPosition,
        mass: paddle.charge / 100 * 10 + 10, // Töltöttség alapján változó méret
        color: player.color,
        velocity: velocity,
      );
      newBalls.add(ball);
      final updatedPaddle = paddle.resetCharge();
      newPaddles[player.position] = updatedPaddle;
      state = state.copyWith(balls: newBalls, paddles: newPaddles);
    }
  }

  void updateFieldSize(Size newSize) {
    // Frissítjük a pálya méretét
    if (newSize.width != state.fieldSize.width ||
        newSize.height != state.fieldSize.height) {
      state = state.copyWith(fieldSize: newSize);
      // Frissítjük a paddle-k pozícióját a pálya méretének megfelelően
      final paddles = {...state.paddles};

      paddles.forEach((position, paddle) {
        Offset newPosition;
        switch (position) {
          case PlayerPosition.left:
            // Bal oldali paddle pozíciója változatlan marad
            newPosition = Offset(paddle.position.dx, newSize.height / 2);
            break;
          case PlayerPosition.right:
            // Jobb oldali paddle pozíciója frissítve
            newPosition =
                Offset(newSize.width - paddle.width / 2, newSize.height / 2);
            break;
          case PlayerPosition.top:
            // Felső paddle pozíciója változatlan marad
            newPosition = Offset(newSize.width / 2, paddle.position.dy);
            break;
          case PlayerPosition.bottom:
            // Alsó paddle pozíciója frissítve
            newPosition = Offset(newSize.width / 2, newSize.height - 60);
            break;
        }

        paddles[position] = paddle.copyWith(position: newPosition);
      });

      // Frissítjük az állapotot a paddle-k új pozícióival
      state = state.copyWith(paddles: paddles);
    }
  }

  void startAIPlayer(AIPlayer aiPlayer) {
    _aiTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      aiPlayer.startPlaying(state, movePaddle, shootBall);
    });
  }

  void stopAIPlayer() {
    for (var player in aiPlayers) {
      player.stopPlaying();
    }
    aiPlayers.clear();
    _aiTimer?.cancel();
  }

  void _checkForWinner() {
    // Ellenőrzés: ha csak egy játékos maradt életben
    final remainingPlayers = state.paddles.values
        .where((paddle) => state.lives[paddle.player.position]! > 0)
        .toList();
    if (remainingPlayers.length == 1) {
      // Van győztes
      final winner = remainingPlayers.first.player.name;
      _endGame(winner);
    }
  }

  void _endGame(String winnerName) {
    stopAIPlayer();
    _chargeTimer?.cancel();
    _fieldRotationTimer?.cancel();
    _ballUpdateTimer?.cancel();
    _aiTimer = null;
    _chargeTimer = null;
    _fieldRotationTimer = null;
    _ballUpdateTimer = null;
    // Állítsd be a játék végét jelző állapotot
    state = state.copyWith(
      isGameOver: true,
      winnerName: winnerName,
    );
    // Kérj megerősítést a hosttól az új játék indítására
    _promptNewGame();
  }

  void _promptNewGame() {
    // Itt kérhetsz megerősítést a hosttól az új játék indításához
    // Például egy dialog megjelenítésével
    // Itt egy egyszerű példát mutatok, ahol az állapotot frissíted a várakozás idejére.
    Future.delayed(const Duration(seconds: 5), () {
      // Ezután indíts új játékot, ha a host úgy döntött
      _resetGame();
    });
  }

  void _resetGame() {
    // Itt visszaállíthatod a játékot az eredeti állapotába
    final fieldSize = state.fieldSize;
    state = GameState.initial(
      state.activePlayers,
      state.currentPlayer,
      state.gravityRule,
    );
    updateFieldSize(fieldSize);
    _startChargeUpdate();
    _startFieldRotationUpdate();
    _startBallUpdate();
    for (var player in state.activePlayers) {
      if (player.isAI) {
        startAIPlayer(AIPlayer(player: player));
      }
    }
  }
}

final gameStateProvider =
    StateNotifierProvider.family<GameStateNotifier, GameState, GameStateArgs>(
  (ref, args) => GameStateNotifier(
    args.activePlayers,
    args.currentPlayer,
    args.gravityRule,
  ),
);
