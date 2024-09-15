import 'package:flutter/material.dart';
import 'package:magnet_pong/models/player.dart';
import 'package:magnet_pong/networking/local_network_service.dart';
import 'game_screen.dart';

class WaitingRoomScreen extends StatefulWidget {
  final LocalNetworkService networkService;
  final bool isHost;

  const WaitingRoomScreen({
    Key? key,
    required this.networkService,
    required this.isHost,
  }) : super(key: key);

  @override
  _WaitingRoomScreenState createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  List<Player> players = [];

  @override
  void initState() {
    super.initState();

    players = widget.networkService.players;

    widget.networkService.onPlayerJoined = (Player newPlayer) {
      setState(() {});
    };

    widget.networkService.onGameStart = () {
      // Navigate to GameScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(
            currentPlayer: widget.networkService.currentPlayer!,
            activePlayers: widget.networkService.players,
            gravityRule: widget.networkService.gravityRule,
            networkService: widget.networkService,
          ),
        ),
      );
    };
  }

  @override
  void dispose() {
    widget.networkService.onPlayerJoined = null;
    widget.networkService.onGameStart = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) =>
          widget.networkService.leaveLobby(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Waiting Room'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Text('Players in lobby:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: player.color,
                    ),
                    title: Text(player.name),
                    subtitle: Text(
                        'Element: ${player.element.toString().split('.').last}'),
                  );
                },
              ),
            ),
            if (widget.isHost)
              ElevatedButton(
                onPressed: () {
                  widget.networkService.startGame();
                },
                child: Text('Start Game'),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
