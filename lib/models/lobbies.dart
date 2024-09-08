import 'package:dart_mappable/dart_mappable.dart';
import 'package:magnet_pong/models/lobby.dart';

part 'lobbies.mapper.dart';

@MappableClass()
class Lobbies with LobbiesMappable {
  final List<Lobby> lobbies;

  Lobbies(this.lobbies);
}
