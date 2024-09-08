import 'package:dart_mappable/dart_mappable.dart';

import 'player.dart';
import 'gravity_rule.dart';

part 'lobby.mapper.dart';

@MappableClass()
class Lobby with LobbyMappable {
  final String id;
  final List<Player> players;
  final bool gameStarted;
  final GravityRule gravityRule;
  final String name;
  final String owner;

  Lobby({
    required this.id,
    required this.players,
    this.gameStarted = false,
    required this.gravityRule,
    required this.name,
    required this.owner,
  });
}
