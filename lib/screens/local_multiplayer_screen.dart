import 'package:flutter/material.dart';
import 'package:magnet_pong/networking/local_network_service.dart';
import 'package:magnet_pong/screens/local_waiting_room_screen.dart';
import 'package:magnet_pong/widgets/neon_button.dart';
import 'package:magnet_pong/widgets/neon_text.dart';
import 'package:magnet_pong/models/element_type.dart';

class LocalMultiplayerScreen extends StatefulWidget {
  const LocalMultiplayerScreen({super.key});

  @override
  _LocalMultiplayerScreenState createState() => _LocalMultiplayerScreenState();
}

class _LocalMultiplayerScreenState extends State<LocalMultiplayerScreen> {
  final _playerNameController = TextEditingController();
  bool _isHosting = false;
  late LocalNetworkService _networkService;
  ElementType _selectedElement = ElementType.fire;

  @override
  void initState() {
    super.initState();
    _networkService = LocalNetworkService();
  }

  @override
  void dispose() {
    _playerNameController.dispose();
    _networkService.dispose();
    super.dispose();
  }

  void _startHosting() async {
    setState(() {
      _isHosting = true;
    });
    await _networkService.startHosting(
      _playerNameController.text.trim(),
      _selectedElement,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WaitingRoomScreen(
          networkService: _networkService,
          isHost: _isHosting,
        ),
      ),
    );
  }

  void _joinGame() async {
    await _networkService.discoverHosts();
    if (_networkService.hostAddress != null) {
      // Set the callback before connecting
      _networkService.onPlayerAssigned = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WaitingRoomScreen(
              networkService: _networkService,
              isHost: false,
            ),
          ),
        );
      };
      await _networkService.connectToHost(
        _playerNameController.text.trim(),
        _selectedElement,
      );
    } else {
      // No host found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No host found on the local network.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NeonText('Local Multiplayer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _playerNameController,
              decoration: const InputDecoration(labelText: 'Your Name'),
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
            const SizedBox(height: 20),
            NeonButton(
              text: 'Host Game',
              onPressed: () => _isHosting ? null : _startHosting(),
            ),
            const SizedBox(height: 20),
            NeonButton(
              text: 'Join Game',
              onPressed: () => _isHosting ? null : _joinGame(),
            ),
            const SizedBox(height: 20),
            if (_isHosting) const NeonText('Waiting for players to join...'),
          ],
        ),
      ),
    );
  }
}
