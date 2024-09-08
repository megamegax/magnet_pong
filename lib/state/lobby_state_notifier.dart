import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magnet_pong/models/element_type.dart';
import 'package:magnet_pong/models/gravity_rule.dart';
import 'package:magnet_pong/models/lobbies.dart';
import 'package:magnet_pong/models/player.dart';
import 'package:magnet_pong/models/player_position.dart';
import '../models/lobby.dart';

final baseUrl = 'http://localhost:8080';
final lobbyProvider = StateNotifierProvider<LobbyStateNotifier, Lobby?>(
    (ref) => LobbyStateNotifier());
// Minden lobby figyelése
final allLobbiesStreamProvider = StreamProvider<List<Lobby>>((ref) {
  final url = Uri.parse('$baseUrl/rooms');
  return http.get(url).asStream().map((lobbies) {
    final rooms = LobbiesMapper.fromJson(lobbies.body).lobbies;
    return rooms.map((room) {
      return Lobby(
          name: room.name,
          owner: room.owner,
          players: room.players.map((serverPlayer) {
            return Player(
                id: serverPlayer.id,
                name: serverPlayer.name,
                color: serverPlayer.color,
                element: ElementType.air,
                position: PlayerPosition.left,
                health: serverPlayer.health.toDouble(),
                isAI: false);
          }).toList(),
          gravityRule: GravityRule.attractSameColor,
          gameStarted: room.gameStarted,
          id: room.id);
    }).toList();
  });
});

// Egy adott lobby figyelése lobbyId alapján
final lobbyStreamProvider =
    StreamProvider.family<Lobby?, String>((ref, lobbyId) {
  final url = Uri.parse('$baseUrl/rooms/$lobbyId');

  // GET kérés végrehajtása
  return http.get(url).asStream().map((roomResponse) {
    final room = LobbyMapper.fromJson(roomResponse.body);
    return room;
  });
});

class LobbyStateNotifier extends StateNotifier<Lobby?> {
  LobbyStateNotifier() : super(null);

  Future<void> createLobby(Player host, GravityRule gravityRule) async {
    final url = Uri.parse('$baseUrl/rooms');
    final lobby = Lobby(
        name: "${host.name}'s game",
        players: [host],
        owner: host.name,
        id: Random().nextInt(100).toString(),
        gameStarted: false,
        gravityRule: gravityRule);
    http.post(url, body: lobby.toJson());

    state = lobby;
  }

  Future<bool> joinLobby(String lobbyId, Player player) async {
    final getRoomUrl = Uri.parse('$baseUrl/rooms/$lobbyId');

    final roomResponse = await http.get(getRoomUrl);
    final lobby = LobbyMapper.fromJson(roomResponse.body);

    if (!lobby.gameStarted && lobby.players.length < 4) {
      // Pozíció kiosztása
      final position = _getNextPlayerPosition(lobby.players);
      final updatedPlayer = player.copyWith(position: position);

      final updatedPlayers = List<Player>.from(lobby.players)
        ..add(updatedPlayer);
      final addPlayerUrl = Uri.parse('$baseUrl/rooms/$lobbyId');
      final playerAddedLobbyResponse =
          await http.put(addPlayerUrl, body: updatedPlayer.toJson());

      final updatedLobby = LobbyMapper.fromJson(playerAddedLobbyResponse.body);
      state = updatedLobby.copyWith(players: updatedPlayers);
      return true;
    }
    return false;
  }

  PlayerPosition _getNextPlayerPosition(List<Player> players) {
    const availablePositions = PlayerPosition.values;
    for (var position in availablePositions) {
      if (!players.any((player) => player.position == position)) {
        return position;
      }
    }
    return PlayerPosition.left; // Default érték, ha valami hiba történik
  }

  Future<void> addAIPlayer(String lobbyId, Player aiPlayer) async {
    final roomUrl = Uri.parse('$baseUrl/rooms/$lobbyId');

    final lobbyResponse = await http.get(roomUrl);
    final lobby = LobbyMapper.fromJson(lobbyResponse.body);

    if (lobby.players.length < 4) {
      final updatedPlayers = List<Player>.from(lobby.players)..add(aiPlayer);
      final updatedLobby = lobby.copyWith(players: updatedPlayers);
      final playerAddedLobbyResponse =
          await http.put(roomUrl, body: updatedLobby.toJson());
      state = updatedLobby;
    }
  }

  Future<void> removePlayer(String lobbyId, Player player) async {
    // final docRef = _firestore.collection('lobbies').doc(lobbyId);
    //  final doc = await docRef.get();

    // final lobby = Lobby.fromMap(doc.id, doc.data()!);
    //   final updatedPlayers = List<Player>.from(lobby.players)
    //    ..removeWhere((p) => p.id == player.id);

    //   await docRef
    //        .update({'players': updatedPlayers.map((p) => p.toMap()).toList()});
    //   state = lobby.copyWith(players: updatedPlayers);
  }

  Future<void> deleteLobby(String lobbyId) async {
    // final docRef = _firestore.collection('lobbies').doc(lobbyId);
    // await docRef.delete();
    state = null;
  }

  void startGame() async {
    final url = Uri.parse('$baseUrl/rooms/${state!.id}');
    if (state != null) {
      final lobbyResponse = await http.get(url);
      final lobby = LobbyMapper.fromJson(lobbyResponse.body);
      final updatedLobby = lobby.copyWith(gameStarted: true);
      http.put(url, body: updatedLobby.toJson());
      state = state!.copyWith(gameStarted: true);
    }
  }
}
