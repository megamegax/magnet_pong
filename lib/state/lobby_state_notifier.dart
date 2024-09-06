import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gravity_pong/models/gravity_rule.dart';
import 'package:gravity_pong/models/player.dart';
import 'package:gravity_pong/models/player_position.dart';
import '../models/lobby.dart';

final lobbyProvider = StateNotifierProvider<LobbyStateNotifier, Lobby?>(
    (ref) => LobbyStateNotifier());
// Minden lobby figyelése
final allLobbiesStreamProvider = StreamProvider<List<Lobby>>((ref) {
  return FirebaseFirestore.instance
      .collection('lobbies')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Lobby.fromMap(doc.id, doc.data());
    }).toList();
  });
});

// Egy adott lobby figyelése lobbyId alapján
final lobbyStreamProvider =
    StreamProvider.family<Lobby?, String>((ref, lobbyId) {
  return FirebaseFirestore.instance
      .collection('lobbies')
      .doc(lobbyId)
      .snapshots()
      .map((snapshot) {
    if (snapshot.exists) {
      return Lobby.fromMap(snapshot.id, snapshot.data()!);
    } else {
      return null;
    }
  });
});

class LobbyStateNotifier extends StateNotifier<Lobby?> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LobbyStateNotifier() : super(null);

  Future<void> createLobby(Player host, GravityRule gravityRule) async {
    final docRef = _firestore.collection('lobbies').doc();
    final lobby = Lobby(
      id: docRef.id,
      players: [host],
      gravityRule: gravityRule,
    );

    await docRef.set(lobby.toMap());
    state = lobby;
  }
  Future<bool> joinLobby(String lobbyId, Player player) async {
    final docRef = _firestore.collection('lobbies').doc(lobbyId);
    final doc = await docRef.get();

    if (doc.exists) {
      final lobby = Lobby.fromMap(doc.id, doc.data()!);
      if (!lobby.gameStarted && lobby.players.length < 4) {
        // Pozíció kiosztása
        final position = _getNextPlayerPosition(lobby.players);
        final updatedPlayer = player.copyWith(position: position);

        final updatedPlayers = List<Player>.from(lobby.players)..add(updatedPlayer);
        await docRef.update({'players': updatedPlayers.map((p) => p.toMap()).toList()});
        state = lobby.copyWith(players: updatedPlayers);
        return true;
      }
    }
    return false;
  }

  PlayerPosition _getNextPlayerPosition(List<Player> players) {
    final availablePositions = PlayerPosition.values;
    for (var position in availablePositions) {
      if (!players.any((player) => player.position == position)) {
        return position;
      }
    }
    return PlayerPosition.left; // Default érték, ha valami hiba történik
  }


  Future<void> addAIPlayer(String lobbyId, Player aiPlayer) async {
    final docRef = _firestore.collection('lobbies').doc(lobbyId);
    final doc = await docRef.get();

    if (doc.exists) {
      final lobby = Lobby.fromMap(doc.id, doc.data()!);
      if (lobby.players.length < 4) {
        final updatedPlayers = List<Player>.from(lobby.players)..add(aiPlayer);
        await docRef
            .update({'players': updatedPlayers.map((p) => p.toMap()).toList()});
        state = lobby.copyWith(players: updatedPlayers);
      }
    }
  }

  Future<void> removePlayer(String lobbyId, Player player) async {
    final docRef = _firestore.collection('lobbies').doc(lobbyId);
    final doc = await docRef.get();

    if (doc.exists) {
      final lobby = Lobby.fromMap(doc.id, doc.data()!);
      final updatedPlayers = List<Player>.from(lobby.players)
        ..removeWhere((p) => p.id == player.id);

      await docRef
          .update({'players': updatedPlayers.map((p) => p.toMap()).toList()});
      state = lobby.copyWith(players: updatedPlayers);
    }
  }

  Future<void> deleteLobby(String lobbyId) async {
    final docRef = _firestore.collection('lobbies').doc(lobbyId);
    await docRef.delete();
    state = null;
  }

  void startGame() async {
    if (state != null) {
      final docRef = _firestore.collection('lobbies').doc(state!.id);
      await docRef.update({'gameStarted': true});
      state = state!.copyWith(gameStarted: true);
    }
  }
}
