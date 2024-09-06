import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gravity_pong/models/color_utils.dart';
import 'package:gravity_pong/models/element_type.dart';
import 'package:gravity_pong/models/player_position.dart';
import 'package:gravity_pong/widgets/neon_button.dart';
import 'package:gravity_pong/widgets/neon_text.dart';
import '../models/player.dart';
import '../state/lobby_state_notifier.dart';
import 'game_screen.dart';
import '../ai/ai_player.dart';

class WaitingRoomScreen extends ConsumerWidget {
  final String lobbyId;
  final Player player;
  final bool isHost;

  WaitingRoomScreen(
      {required this.lobbyId, required this.player, this.isHost = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lobbyAsyncValue = ref.watch(lobbyStreamProvider(lobbyId));

    return WillPopScope(
      onWillPop: () async {
        if (isHost) {
          final lobbyState = ref.read(lobbyProvider);
          if (lobbyState?.gameStarted == false) {
            await ref.read(lobbyProvider.notifier).deleteLobby(lobbyId);
          }
        } else {
          await ref.read(lobbyProvider.notifier).removePlayer(lobbyId, player);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: NeonText('Waiting Room'),
        ),
        body: lobbyAsyncValue.when(
          data: (lobby) {
            if (lobby == null) {
              return Center(
                child: NeonText('Lobby not found or has been closed.'),
              );
            }

            if (lobby.gameStarted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                        currentPlayer: player,
                        gravityRule: lobby.gravityRule,
                        activePlayers: lobby.players),
                  ),
                );
              });
            }

            return Column(
              children: [
                NeonText('Waiting for the host to start the game...'),
                SizedBox(height: 20),
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
                                  name: 'AI Player ${lobby.players.length + 1}',
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
                        child: NeonText('Add AI Player'),
                      ),
                      SizedBox(height: 10),
                      NeonButton(
                        onPressed: () {
                          ref.read(lobbyProvider.notifier).startGame();
                        },
                        text: ('Start Game'),
                      ),
                    ],
                  ),
              ],
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  PlayerPosition _getNextPlayerPosition(List<Player> players) {
    final positions = PlayerPosition.values;
    for (var position in positions) {
      if (!players.any((player) => player.position == position)) {
        return position;
      }
    }
    return PlayerPosition.top; // default, ha minden pozíció foglalt
  }
}
