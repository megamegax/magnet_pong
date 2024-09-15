import 'package:flutter/foundation.dart';
import 'package:magnet_pong/networking/local_network_service.dart';

import '../models/player.dart';
import '../models/gravity_rule.dart';

class GameStateArgs {
  final List<Player> activePlayers;
  final Player currentPlayer;
  final GravityRule gravityRule;
  final bool isHost;
  final LocalNetworkService? networkService;

  GameStateArgs({
    required this.activePlayers,
    required this.currentPlayer,
    required this.gravityRule,
    required this.isHost,
    this.networkService,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GameStateArgs &&
        listEquals(other.activePlayers, activePlayers) &&
        other.currentPlayer == currentPlayer &&
        other.gravityRule == gravityRule &&
        other.isHost == isHost;
  }

  @override
  int get hashCode =>
      activePlayers.hashCode ^
      currentPlayer.hashCode ^
      gravityRule.hashCode ^
      isHost.hashCode;
}
