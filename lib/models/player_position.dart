import 'package:dart_mappable/dart_mappable.dart';
part 'player_position.mapper.dart';

@MappableEnum()
enum PlayerPosition {
  left,
  right,
  top,
  bottom,
}
