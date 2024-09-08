import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magnet_pong/models/color_utils.dart';
import 'package:magnet_pong/models/player_position.dart';
import 'package:magnet_pong/widgets/neon_button.dart';
import 'package:magnet_pong/widgets/neon_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';
import '../models/element_type.dart';
import '../models/gravity_rule.dart';
import '../state/lobby_state_notifier.dart';
import 'waiting_room_screen.dart';

class HostSettingsScreen extends ConsumerStatefulWidget {
  const HostSettingsScreen({super.key});

  @override
  _HostSettingsScreenState createState() => _HostSettingsScreenState();
}

class _HostSettingsScreenState extends ConsumerState<HostSettingsScreen> {
  final _hostNameController = TextEditingController();
  GravityRule _selectedRule = GravityRule.attractSameColor;
  ElementType _selectedElement = ElementType.fire;
  String? _savedName;
  @override
  void initState() {
    super.initState();
    resetColors();
    _loadName();
  }

  Future<void> _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('playerName');
      _hostNameController.text = _savedName ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NeonText('Host Settings', style: TextStyle(fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _hostNameController,
              decoration: const InputDecoration(labelText: 'Host Name'),
            ),
            const SizedBox(height: 20),
            const NeonText('Select Gravity Rule:',
                style: TextStyle(fontSize: 20)),
            ListTile(
              title: const NeonText('Attract same color'),
              leading: Radio<GravityRule>(
                value: GravityRule.attractSameColor,
                groupValue: _selectedRule,
                onChanged: (GravityRule? value) {
                  setState(() {
                    _selectedRule = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const NeonText('Repel same color'),
              leading: Radio<GravityRule>(
                value: GravityRule.repelSameColor,
                groupValue: _selectedRule,
                onChanged: (GravityRule? value) {
                  setState(() {
                    _selectedRule = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            const NeonText('Select Your Element:',
                style: TextStyle(fontSize: 20)),
            ListTile(
              title: const NeonText('Fire'),
              leading: Radio<ElementType>(
                value: ElementType.fire,
                groupValue: _selectedElement,
                onChanged: (ElementType? value) {
                  setState(() {
                    _selectedElement = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const NeonText('Water'),
              leading: Radio<ElementType>(
                value: ElementType.water,
                groupValue: _selectedElement,
                onChanged: (ElementType? value) {
                  setState(() {
                    _selectedElement = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const NeonText('Stone'),
              leading: Radio<ElementType>(
                value: ElementType.stone,
                groupValue: _selectedElement,
                onChanged: (ElementType? value) {
                  setState(() {
                    _selectedElement = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const NeonText('Air'),
              leading: Radio<ElementType>(
                value: ElementType.air,
                groupValue: _selectedElement,
                onChanged: (ElementType? value) {
                  setState(() {
                    _selectedElement = value!;
                  });
                },
              ),
            ),
            const Spacer(),
            NeonButton(
              verticalPadding: 15,
              horizontalPadding: 20,
              fontSize: 16,
              onPressed: () async {
                final host = Player(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _hostNameController.text.trim(),
                  element: _selectedElement,
                  position: PlayerPosition.left,
                  color: getNextColor(context),
                  isAI: false,
                );

                await ref
                    .read(lobbyProvider.notifier)
                    .createLobby(host, _selectedRule);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WaitingRoomScreen(
                      lobbyId: ref.read(lobbyProvider)!.id,
                      player: host,
                      isHost: true, // A host speciális jogosultságokkal lép be
                    ),
                  ),
                );
              },
              text: 'Create Lobby',
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hostNameController.dispose();
    super.dispose();
  }
}
