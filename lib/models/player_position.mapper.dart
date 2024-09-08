// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'player_position.dart';

class PlayerPositionMapper extends EnumMapper<PlayerPosition> {
  PlayerPositionMapper._();

  static PlayerPositionMapper? _instance;
  static PlayerPositionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PlayerPositionMapper._());
    }
    return _instance!;
  }

  static PlayerPosition fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  PlayerPosition decode(dynamic value) {
    switch (value) {
      case 'left':
        return PlayerPosition.left;
      case 'right':
        return PlayerPosition.right;
      case 'top':
        return PlayerPosition.top;
      case 'bottom':
        return PlayerPosition.bottom;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(PlayerPosition self) {
    switch (self) {
      case PlayerPosition.left:
        return 'left';
      case PlayerPosition.right:
        return 'right';
      case PlayerPosition.top:
        return 'top';
      case PlayerPosition.bottom:
        return 'bottom';
    }
  }
}

extension PlayerPositionMapperExtension on PlayerPosition {
  String toValue() {
    PlayerPositionMapper.ensureInitialized();
    return MapperContainer.globals.toValue<PlayerPosition>(this) as String;
  }
}
