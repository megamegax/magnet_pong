import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:magnet_pong/models/player.dart';
import 'package:magnet_pong/models/gravity_rule.dart';
import 'package:magnet_pong/models/element_type.dart';
import 'package:magnet_pong/models/player_position.dart';

class LocalNetworkService {
  ServerSocket? _serverSocket;
  Socket? _clientSocket;
  List<Socket> _connectedClients = [];
  bool isHost = false;
  InternetAddress? hostAddress;
  Function(Player)? onPlayerJoined;
  Function()? onGameStart;
  Player? currentPlayer;
  List<Player> players = [];
  GravityRule gravityRule = GravityRule.attractSameColor;
  Function()? onPlayerAssigned;
  Function(String, Map<String, dynamic>)? onInputReceived;
  Function(Map<String, dynamic>)? onGameStateReceived;
  // Új: Elérhető pozíciók és színek listája
  final List<PlayerPosition> availablePositions =
      List.from(PlayerPosition.values);
  final List<Color> availableColors = [
    const Color(0xFFFF0000), // Piros
    const Color(0xFF00FF00), // Zöld
    const Color(0xFF0000FF), // Kék
    const Color(0xFFFFFF00), // Sárga
  ];

  Future<void> startHosting(String hostName, ElementType hostElement) async {
    isHost = true;
    _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 5050);
    print(
        'Server is listening on ${_serverSocket?.address.address}:${_serverSocket?.port}');
    _serverSocket!.listen(_handleClient);
    _startDiscoveryListener();

    // Host pozíció és szín kiosztása
    final hostPosition = _assignNextPosition();
    final hostColor = _assignNextColor();

    currentPlayer = Player(
      id: _generateId(),
      name: hostName,
      element: hostElement,
      position: hostPosition,
      color: hostColor,
      isAI: false,
    );
    players.add(currentPlayer!);
  }

  void _handleClient(Socket client) {
    print(
        'New client connected from ${client.remoteAddress.address}:${client.remotePort}');
    _connectedClients.add(client);

    client
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((message) {
      final json = jsonDecode(message);

      if (json['type'] == 'join') {
        // Játékos csatlakozik
        final String playerName = json['name'];
        final ElementType playerElement =
            ElementType.values.firstWhere((e) => e.name == json['element']);

        // Pozíció és szín kiosztása
        final assignedPosition = _assignNextPosition();
        final assignedColor = _assignNextColor();

        final newPlayer = Player(
          id: _generateId(),
          name: playerName,
          element: playerElement,
          position: assignedPosition,
          color: assignedColor,
          isAI: false,
        );
        players.add(newPlayer);

        onPlayerJoined?.call(newPlayer);

        // Visszaküldjük a kliensnek a kiosztott adatokat
        client.write('${jsonEncode({
              'type': 'player_assigned',
              'player': newPlayer.toJson(),
              'players': players.map((p) => p.toJson()).toList(),
            })}\n');

        // Értesítjük a többi klienst az új játékosról
        _broadcastToClients({
          'type': 'player_joined',
          'player': newPlayer.toJson(),
        }, exclude: client);
      } else if (json['type'] == 'input') {
        final playerId = json['data']['playerId'];
        final inputData = json['data'];
        onInputReceived?.call(playerId, inputData);
      } else if (json['type'] == 'gameState') {
        // If clients send game state updates (in P2P models)
        if (onGameStateReceived != null) {
          onGameStateReceived!(json['data']);
        }
      }
    }, onDone: () {
      _connectedClients.remove(client);
    });
  }

  void startGame() {
    // Send 'start_game' message to all clients
    final message = jsonEncode({'type': 'start_game'});
    for (var client in _connectedClients) {
      client.write('$message\n');
    }

    // Also, on host, call onGameStart callback
    if (onGameStart != null) {
      onGameStart!();
    }
  }

  void _broadcastToClients(Map<String, dynamic> message, {Socket? exclude}) {
    final jsonString = jsonEncode(message);
    for (var client in _connectedClients) {
      if (client != exclude) {
        client.write('$jsonString\n');
      }
    }
  }

  Future<String> getLocalIP() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
          return addr.address;
        }
      }
    }
    return '127.0.0.1';
  }

  void _startDiscoveryListener() {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 4041).then((socket) {
      socket.listen((event) async {
        if (event == RawSocketEvent.read) {
          final dg = socket.receive();
          if (dg != null) {
            final message = utf8.decode(dg.data);
            if (message == 'DISCOVER_PONG_SERVER') {
              String localIP = await getLocalIP();
              socket.send(
                utf8.encode('PONG_SERVER_HERE|$localIP'),
                dg.address,
                dg.port,
              );
            }
          }
        }
      });
    });
  }

  Future<void> discoverHosts() async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    socket.broadcastEnabled = true;
    socket.send(
      utf8.encode('DISCOVER_PONG_SERVER'),
      InternetAddress('255.255.255.255'),
      4041,
    );

    final completer = Completer();
    socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final dg = socket.receive();
        if (dg != null) {
          final message = utf8.decode(dg.data);
          if (message.startsWith('PONG_SERVER_HERE|')) {
            final parts = message.split('|');
            if (parts.length == 2) {
              hostAddress = InternetAddress(parts[1]);
            } else {
              hostAddress = dg.address;
            }
            print('Discovered host at $hostAddress');
            completer.complete();
            socket.close();
          }
        }
      }
    });

    await completer.future.timeout(const Duration(seconds: 5), onTimeout: () {
      print('Host discovery timed out');
      socket.close();
    });
  }

  Future<void> connectToHost(String playerName, ElementType elementType) async {
    if (hostAddress != null) {
      try {
        print('Attempting to connect to host at $hostAddress:5050');
        _clientSocket = await Socket.connect(hostAddress!, 5050);
        print('Connected to host');

        _clientSocket!.write('${jsonEncode({
              'type': 'join',
              'name': playerName,
              'element': elementType.name,
            })}\n');

        _clientSocket
            ?.cast<List<int>>()
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen((message) {
          final json = jsonDecode(message);
          if (json['type'] == 'player_assigned') {
            // Host visszaküldi a kiosztott adatokat
            currentPlayer = PlayerMapper.fromJson(json['player']);
            players = (json['players'] as List)
                .map((p) => PlayerMapper.fromJson(p))
                .toList();
            if (onPlayerAssigned != null) {
              onPlayerAssigned!();
            }
            // Játék indítása
            //   onGameStart?.call();
          } else if (json['type'] == 'player_joined') {
            // Új játékos csatlakozott
            final newPlayer = PlayerMapper.fromJson(json['player']);
            players.add(newPlayer);
          } else if (json['type'] == 'start_game') {
            // Host has started the game
            if (onGameStart != null) {
              onGameStart!();
            }
          } else if (json['type'] == 'gameState') {
            if (onGameStateReceived != null) {
              onGameStateReceived!(json['data']);
            }
          }
        });
      } catch (e) {
        print('Error connecting to host: $e');
      }
    } else {
      print('No host found');
    }
  }

  void sendInput(Map<String, dynamic> input) {
    if (_clientSocket != null) {
      final message = '${jsonEncode({'type': 'input', 'data': input})}\n';

      _clientSocket!.write(message);
    } else if (isHost) {
      // Hostként kezeljük a bemenetet
    }
  }

  void broadcastGameState(String gameStateJson) {
    final message = """{"type": "gameState", "data": $gameStateJson}\n""";
    for (var client in _connectedClients) {
      client.write('$message\n');
    }
  }

  void dispose() {
    _serverSocket?.close();
    _clientSocket?.destroy();
    for (var client in _connectedClients) {
      client.destroy();
    }
    _connectedClients.clear();
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  PlayerPosition _assignNextPosition() {
    if (availablePositions.isNotEmpty) {
      return availablePositions.removeAt(0);
    } else {
      throw Exception('No available positions left');
    }
  }

  Color _assignNextColor() {
    if (availableColors.isNotEmpty) {
      return availableColors.removeAt(0);
    } else {
      // Ha elfogytak az előre definiált színek, generáljunk véletlenszerűt
      return _getRandomColor();
    }
  }

  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  leaveLobby() {
    dispose();
  }
}
