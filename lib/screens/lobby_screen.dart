import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gravity_pong/models/element_type.dart';
import 'package:gravity_pong/models/player_position.dart';
import 'package:gravity_pong/widgets/neon_button.dart';
import 'package:gravity_pong/widgets/neon_text.dart';
import '../models/player.dart';
import '../state/lobby_state_notifier.dart';
import 'waiting_room_screen.dart';
import 'host_settings_screen.dart';

class LobbyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lobbiesStream = ref.watch(allLobbiesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: NeonText('Join or Host a Game'),
      ),
      body: Column(
        children: [
          Expanded(
            child: lobbiesStream.when(
              data: (lobbies) {
                if (lobbies.isEmpty) {
                  return Center(child: NeonText('No available lobbies.'));
                }
                return ListView.builder(
                  itemCount: lobbies.length,
                  itemBuilder: (context, index) {
                    final lobby = lobbies[index];
                    return ListTile(
                      title: Text(
                          'Host: ${lobby.players.first.name} (${lobby.players.length}/4)'),
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
              loading: () => Center(child: CircularProgressIndicator()),
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
              title: NeonText('Join Lobby'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: 'Enter your name'),
                  ),
                  SizedBox(height: 20),
                  NeonText('Select Your Element:'),
                  ListTile(
                    title: NeonText('Water'),
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
                    title: NeonText('Fire'),
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
                    title: NeonText('Stone'),
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
                    title: NeonText('Air'),
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
                          title: NeonText('Unable to Join'),
                          content: NeonText(
                              'The lobby could not be joined. Please try again later.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: NeonText('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: NeonText('Join'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
