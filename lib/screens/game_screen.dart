import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magnet_pong/models/gravity_rule.dart';
import 'package:magnet_pong/models/player_position.dart';
import 'package:magnet_pong/networking/local_network_service.dart';
import 'package:magnet_pong/state/game_state_args.dart';
import 'package:magnet_pong/painters/game_painter.dart';
import '../models/player.dart';
import '../state/game_state_notifier.dart';

class GameScreen extends ConsumerWidget {
  final Player currentPlayer;
  final List<Player> activePlayers;
  final GravityRule gravityRule;
  final LocalNetworkService? networkService;

  const GameScreen({
    Key? key,
    required this.currentPlayer,
    required this.activePlayers,
    required this.gravityRule,
    this.networkService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final gameStateArgs = GameStateArgs(
      activePlayers: activePlayers,
      currentPlayer: currentPlayer,
      gravityRule: gravityRule,
      networkService: networkService,
      isHost: networkService?.isHost ?? false,
    );

    Future.microtask(() {
      ref.read(gameStateProvider(gameStateArgs).notifier).updateFieldSize(size);
    });

    final gameStateNotifier =
        ref.read(gameStateProvider(gameStateArgs).notifier);

    if (networkService != null) {
      if (networkService!.isHost) {
        networkService!.onInputReceived = (playerId, inputData) {
          gameStateNotifier.handlePlayerInput(playerId, inputData);
        };
      } else {
        networkService!.onGameStateReceived = (gameStateData) {
          print('Received game state from host');
          ref
              .read(gameStateProvider(gameStateArgs).notifier)
              .updateFromNetwork(gameStateData);
        };
      }
    }

    final gameState = ref.watch(gameStateProvider(gameStateArgs));

    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: gameState.paddles.keys.map((playerPosition) {
              return Column(
                children: [
                  Text(
                    gameState.paddles[playerPosition]!.player.name,
                    style: TextStyle(
                      color: gameState.paddles[playerPosition]!.player.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 100,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: max(
                              gameState.lives[playerPosition]?.toDouble() ??
                                  100,
                              0.0),
                          height: 10,
                          decoration: BoxDecoration(
                            color:
                                gameState.paddles[playerPosition]!.player.color,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                if (currentPlayer.position == PlayerPosition.left ||
                    currentPlayer.position == PlayerPosition.right) {
                  // Függőleges mozgás
                  ref
                      .read(gameStateProvider(gameStateArgs).notifier)
                      .movePaddle(currentPlayer, details.delta.dy);
                } else {
                  // Vízszintes mozgás
                  ref
                      .read(gameStateProvider(gameStateArgs).notifier)
                      .movePaddle(currentPlayer, details.delta.dx);
                }
              },
              onPanEnd: (details) {
                ref
                    .read(gameStateProvider(gameStateArgs).notifier)
                    .shootBall(currentPlayer);
              },
              child: CustomPaint(
                size: Size.infinite,
                painter: GamePainter(gameState, context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
