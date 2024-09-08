// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'player.dart';

class PlayerMapper extends ClassMapperBase<Player> {
  PlayerMapper._();

  static PlayerMapper? _instance;
  static PlayerMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PlayerMapper._());
      MapperContainer.globals.useAll([ColorMapper(), MaterialColorMapper()]);
      ElementTypeMapper.ensureInitialized();
      PlayerPositionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Player';

  static String _$id(Player v) => v.id;
  static const Field<Player, String> _f$id = Field('id', _$id);
  static String _$name(Player v) => v.name;
  static const Field<Player, String> _f$name = Field('name', _$name);
  static ElementType _$element(Player v) => v.element;
  static const Field<Player, ElementType> _f$element =
      Field('element', _$element);
  static PlayerPosition _$position(Player v) => v.position;
  static const Field<Player, PlayerPosition> _f$position =
      Field('position', _$position);
  static Color _$color(Player v) => v.color;
  static const Field<Player, Color> _f$color = Field('color', _$color);
  static double _$health(Player v) => v.health;
  static const Field<Player, double> _f$health =
      Field('health', _$health, opt: true, def: 100.0);
  static bool _$isAI(Player v) => v.isAI;
  static const Field<Player, bool> _f$isAI =
      Field('isAI', _$isAI, opt: true, def: false);

  @override
  final MappableFields<Player> fields = const {
    #id: _f$id,
    #name: _f$name,
    #element: _f$element,
    #position: _f$position,
    #color: _f$color,
    #health: _f$health,
    #isAI: _f$isAI,
  };

  static Player _instantiate(DecodingData data) {
    return Player(
        id: data.dec(_f$id),
        name: data.dec(_f$name),
        element: data.dec(_f$element),
        position: data.dec(_f$position),
        color: data.dec(_f$color),
        health: data.dec(_f$health),
        isAI: data.dec(_f$isAI));
  }

  @override
  final Function instantiate = _instantiate;

  static Player fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Player>(map);
  }

  static Player fromJson(String json) {
    return ensureInitialized().decodeJson<Player>(json);
  }
}

mixin PlayerMappable {
  String toJson() {
    return PlayerMapper.ensureInitialized().encodeJson<Player>(this as Player);
  }

  Map<String, dynamic> toMap() {
    return PlayerMapper.ensureInitialized().encodeMap<Player>(this as Player);
  }

  PlayerCopyWith<Player, Player, Player> get copyWith =>
      _PlayerCopyWithImpl(this as Player, $identity, $identity);
  @override
  String toString() {
    return PlayerMapper.ensureInitialized().stringifyValue(this as Player);
  }

  @override
  bool operator ==(Object other) {
    return PlayerMapper.ensureInitialized().equalsValue(this as Player, other);
  }

  @override
  int get hashCode {
    return PlayerMapper.ensureInitialized().hashValue(this as Player);
  }
}

extension PlayerValueCopy<$R, $Out> on ObjectCopyWith<$R, Player, $Out> {
  PlayerCopyWith<$R, Player, $Out> get $asPlayer =>
      $base.as((v, t, t2) => _PlayerCopyWithImpl(v, t, t2));
}

abstract class PlayerCopyWith<$R, $In extends Player, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? name,
      ElementType? element,
      PlayerPosition? position,
      Color? color,
      double? health,
      bool? isAI});
  PlayerCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PlayerCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Player, $Out>
    implements PlayerCopyWith<$R, Player, $Out> {
  _PlayerCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Player> $mapper = PlayerMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? name,
          ElementType? element,
          PlayerPosition? position,
          Color? color,
          double? health,
          bool? isAI}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (name != null) #name: name,
        if (element != null) #element: element,
        if (position != null) #position: position,
        if (color != null) #color: color,
        if (health != null) #health: health,
        if (isAI != null) #isAI: isAI
      }));
  @override
  Player $make(CopyWithData data) => Player(
      id: data.get(#id, or: $value.id),
      name: data.get(#name, or: $value.name),
      element: data.get(#element, or: $value.element),
      position: data.get(#position, or: $value.position),
      color: data.get(#color, or: $value.color),
      health: data.get(#health, or: $value.health),
      isAI: data.get(#isAI, or: $value.isAI));

  @override
  PlayerCopyWith<$R2, Player, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PlayerCopyWithImpl($value, $cast, t);
}
