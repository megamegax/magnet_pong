import 'player.dart';
import 'gravity_rule.dart';

class Lobby {
  final String id;
  final List<Player> players;
  final bool gameStarted;
  final GravityRule gravityRule; // Új mező hozzáadása

  Lobby({
    required this.id,
    required this.players,
    this.gameStarted = false,
    required this.gravityRule, // Új mező inicializálása
  });

  Map<String, dynamic> toMap() {
    return {
      'players': players.map((player) => player.toMap()).toList(),
      'gameStarted': gameStarted,
      'gravityRule': gravityRule.index, // GravityRule tárolása indexként
    };
  }

  factory Lobby.fromMap(String id, Map<String, dynamic> map) {
    return Lobby(
      id: id,
      players: List<Player>.from(map['players']?.map((x) => Player.fromMap(x))),
      gameStarted: map['gameStarted'] ?? false,
      gravityRule: GravityRule.values[map['gravityRule'] ?? 0], // GravityRule visszaállítása index alapján
    );
  }

  Lobby copyWith({
    List<Player>? players,
    bool? gameStarted,
    GravityRule? gravityRule, // Új mező hozzáadása a copyWith-hez is
  }) {
    return Lobby(
      id: id,
      players: players ?? this.players,
      gameStarted: gameStarted ?? this.gameStarted,
      gravityRule: gravityRule ?? this.gravityRule, // Új mező másolása
    );
  }
}