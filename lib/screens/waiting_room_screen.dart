import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magnet_pong/models/color_utils.dart';
import 'package:magnet_pong/models/element_type.dart';
import 'package:magnet_pong/models/player_position.dart';
import 'package:magnet_pong/widgets/neon_button.dart';
import 'package:magnet_pong/widgets/neon_text.dart';
import '../models/player.dart';
import '../state/lobby_state_notifier.dart';
import 'game_screen.dart';
import '../ai/ai_player.dart';

class WaitingRoomScreen extends ConsumerWidget {
  final String lobbyId;
  final Player player;
  final bool isHost;

  const WaitingRoomScreen(
      {super.key,
      required this.lobbyId,
      required this.player,
      this.isHost = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lobby = ref.watch(lobbyProvider);
    if (lobby?.gameStarted ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(
                currentPlayer: player,
                gravityRule: lobby!.gravityRule,
                activePlayers: lobby.players),
          ),
        );
      });
    }
    return PopScope(
      onPopInvokedWithResult: (a, b) async {
        if (isHost) {
          final lobbyState = ref.read(lobbyProvider);
          if (lobbyState?.gameStarted == false) {
            await ref.read(lobbyProvider.notifier).deleteLobby(lobbyId);
          }
        } else {
          await ref.read(lobbyProvider.notifier).removePlayer(lobbyId, player);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const NeonText('Waiting Room'),
          ),
          body: lobby == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const NeonText('Waiting for the host to start the game...'),
                    const SizedBox(height: 20),
                    NeonText('Players in lobby (${lobby.players.length}/4):'),
                    ...lobby.players.map((p) => ListTile(
                          title: Text(p.name, style: TextStyle(color: p.color)),
                          subtitle: NeonText(
                              'Element: ${p.element.toString().split('.').last}'),
                        )),
                    if (isHost)
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: lobby.players.length < 4
                                ? () {
                                    final aiPlayer = AIPlayer(
                                        player: Player(
                                      id: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      name:
                                          'AI Player ${lobby.players.length + 1}',
                                      element: ElementType.stone,
                                      position:
                                          _getNextPlayerPosition(lobby.players),
                                      color: getNextColor(context),
                                    ));

                                    ref
                                        .read(lobbyProvider.notifier)
                                        .addAIPlayer(lobbyId, aiPlayer);
                                  }
                                : null,
                            child: const NeonText('Add AI Player'),
                          ),
                          const SizedBox(height: 10),
                          NeonButton(
                            onPressed: () {
                              ref.read(lobbyProvider.notifier).startGame();
                            },
                            text: ('Start Game'),
                          ),
                        ],
                      ),
                  ],
                )),
    );
  }

  PlayerPosition _getNextPlayerPosition(List<Player> players) {
    const positions = PlayerPosition.values;
    for (var position in positions) {
      if (!players.any((player) => player.position == position)) {
        return position;
      }
    }
    return PlayerPosition.top; // default, ha minden pozíció foglalt
  }
}
