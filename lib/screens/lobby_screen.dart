import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magnet_pong/models/element_type.dart';
import 'package:magnet_pong/models/player_position.dart';
import 'package:magnet_pong/widgets/neon_button.dart';
import 'package:magnet_pong/widgets/neon_text.dart';
import '../models/player.dart';
import '../state/lobby_state_notifier.dart';
import 'waiting_room_screen.dart';
import 'host_settings_screen.dart';

class LobbyScreen extends ConsumerWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lobbiesStream = ref.watch(allLobbiesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const NeonText('Join or Host a Game'),
      ),
      body: Column(
        children: [
          Expanded(
            child: lobbiesStream.when(
              data: (lobbies) {
                if (lobbies.isEmpty) {
                  return const Center(child: NeonText('No available lobbies.'));
                }
                return ListView.builder(
                  itemCount: lobbies.length,
                  itemBuilder: (context, index) {
                    final lobby = lobbies[index];
                    return ListTile(
                      title: Text(
                          'Host: ${lobby.name} (${lobby.players.length}/4)'),
                      subtitle: Text('Lobby ID: ${lobby.id}'),
                      onTap: lobby.players.length < 4
                          ? () {
                              _showJoinDialog(context, ref, lobby.id);
                            }
                          : null,
                      enabled: lobby.players.length < 4,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: NeonText('Error: $err')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: NeonButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HostSettingsScreen(),
                  ),
                );
              },
              text: 'Host a Game',
            ),
          ),
        ],
      ),
    );
  }

  void _showJoinDialog(BuildContext context, WidgetRef ref, String lobbyId) {
    final nameController = TextEditingController();
    ElementType selectedElement = ElementType.water;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const NeonText('Join Lobby'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(hintText: 'Enter your name'),
                  ),
                  const SizedBox(height: 20),
                  const NeonText('Select Your Element:'),
                  ListTile(
                    title: const NeonText('Water'),
                    leading: Radio<ElementType>(
                      value: ElementType.water,
                      groupValue: selectedElement,
                      onChanged: (ElementType? value) {
                        setState(() {
                          selectedElement = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const NeonText('Fire'),
                    leading: Radio<ElementType>(
                      value: ElementType.fire,
                      groupValue: selectedElement,
                      onChanged: (ElementType? value) {
                        setState(() {
                          selectedElement = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const NeonText('Stone'),
                    leading: Radio<ElementType>(
                      value: ElementType.stone,
                      groupValue: selectedElement,
                      onChanged: (ElementType? value) {
                        setState(() {
                          selectedElement = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const NeonText('Air'),
                    leading: Radio<ElementType>(
                      value: ElementType.air,
                      groupValue: selectedElement,
                      onChanged: (ElementType? value) {
                        setState(() {
                          selectedElement = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final player = Player(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text.trim(),
                      element: selectedElement,
                      position: PlayerPosition.top,
                      color: Colors.blue,
                    );

                    // Hívás és eredmény ellenőrzése
                    final success = await ref
                        .read(lobbyProvider.notifier)
                        .joinLobby(lobbyId, player);

                    if (success) {
                      Navigator.of(context).pop(); // Bezárjuk a dialógust
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaitingRoomScreen(
                              lobbyId: lobbyId, player: player),
                        ),
                      );
                    } else {
                      // Hibakezelés, ha a csatlakozás nem sikerül
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const NeonText('Unable to Join'),
                          content: const NeonText(
                              'The lobby could not be joined. Please try again later.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const NeonText('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const NeonText('Join'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
