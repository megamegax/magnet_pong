import 'package:flutter/foundation.dart';

import '../models/player.dart';
import '../models/gravity_rule.dart';

class GameStateArgs {
  final List<Player> activePlayers;
  final Player currentPlayer;
  final GravityRule gravityRule;

  GameStateArgs({
    required this.activePlayers,
    required this.currentPlayer,
    required this.gravityRule,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GameStateArgs &&
        listEquals(other.activePlayers, activePlayers) &&
        other.currentPlayer == currentPlayer &&
        other.gravityRule == gravityRule;
  }

  @override
  int get hashCode =>
      activePlayers.hashCode ^ currentPlayer.hashCode ^ gravityRule.hashCode;
}
