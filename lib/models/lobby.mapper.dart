// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'lobby.dart';

class LobbyMapper extends ClassMapperBase<Lobby> {
  LobbyMapper._();

  static LobbyMapper? _instance;
  static LobbyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LobbyMapper._());
      PlayerMapper.ensureInitialized();
      GravityRuleMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Lobby';

  static String _$id(Lobby v) => v.id;
  static const Field<Lobby, String> _f$id = Field('id', _$id);
  static List<Player> _$players(Lobby v) => v.players;
  static const Field<Lobby, List<Player>> _f$players =
      Field('players', _$players);
  static bool _$gameStarted(Lobby v) => v.gameStarted;
  static const Field<Lobby, bool> _f$gameStarted =
      Field('gameStarted', _$gameStarted, opt: true, def: false);
  static GravityRule _$gravityRule(Lobby v) => v.gravityRule;
  static const Field<Lobby, GravityRule> _f$gravityRule =
      Field('gravityRule', _$gravityRule);
  static String _$name(Lobby v) => v.name;
  static const Field<Lobby, String> _f$name = Field('name', _$name);
  static String _$owner(Lobby v) => v.owner;
  static const Field<Lobby, String> _f$owner = Field('owner', _$owner);

  @override
  final MappableFields<Lobby> fields = const {
    #id: _f$id,
    #players: _f$players,
    #gameStarted: _f$gameStarted,
    #gravityRule: _f$gravityRule,
    #name: _f$name,
    #owner: _f$owner,
  };

  static Lobby _instantiate(DecodingData data) {
    return Lobby(
        id: data.dec(_f$id),
        players: data.dec(_f$players),
        gameStarted: data.dec(_f$gameStarted),
        gravityRule: data.dec(_f$gravityRule),
        name: data.dec(_f$name),
        owner: data.dec(_f$owner));
  }

  @override
  final Function instantiate = _instantiate;

  static Lobby fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Lobby>(map);
  }

  static Lobby fromJson(String json) {
    return ensureInitialized().decodeJson<Lobby>(json);
  }
}

mixin LobbyMappable {
  String toJson() {
    return LobbyMapper.ensureInitialized().encodeJson<Lobby>(this as Lobby);
  }

  Map<String, dynamic> toMap() {
    return LobbyMapper.ensureInitialized().encodeMap<Lobby>(this as Lobby);
  }

  LobbyCopyWith<Lobby, Lobby, Lobby> get copyWith =>
      _LobbyCopyWithImpl(this as Lobby, $identity, $identity);
  @override
  String toString() {
    return LobbyMapper.ensureInitialized().stringifyValue(this as Lobby);
  }

  @override
  bool operator ==(Object other) {
    return LobbyMapper.ensureInitialized().equalsValue(this as Lobby, other);
  }

  @override
  int get hashCode {
    return LobbyMapper.ensureInitialized().hashValue(this as Lobby);
  }
}

extension LobbyValueCopy<$R, $Out> on ObjectCopyWith<$R, Lobby, $Out> {
  LobbyCopyWith<$R, Lobby, $Out> get $asLobby =>
      $base.as((v, t, t2) => _LobbyCopyWithImpl(v, t, t2));
}

abstract class LobbyCopyWith<$R, $In extends Lobby, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Player, PlayerCopyWith<$R, Player, Player>> get players;
  $R call(
      {String? id,
      List<Player>? players,
      bool? gameStarted,
      GravityRule? gravityRule,
      String? name,
      String? owner});
  LobbyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LobbyCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Lobby, $Out>
    implements LobbyCopyWith<$R, Lobby, $Out> {
  _LobbyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Lobby> $mapper = LobbyMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Player, PlayerCopyWith<$R, Player, Player>> get players =>
      ListCopyWith($value.players, (v, t) => v.copyWith.$chain(t),
          (v) => call(players: v));
  @override
  $R call(
          {String? id,
          List<Player>? players,
          bool? gameStarted,
          GravityRule? gravityRule,
          String? name,
          String? owner}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (players != null) #players: players,
        if (gameStarted != null) #gameStarted: gameStarted,
        if (gravityRule != null) #gravityRule: gravityRule,
        if (name != null) #name: name,
        if (owner != null) #owner: owner
      }));
  @override
  Lobby $make(CopyWithData data) => Lobby(
      id: data.get(#id, or: $value.id),
      players: data.get(#players, or: $value.players),
      gameStarted: data.get(#gameStarted, or: $value.gameStarted),
      gravityRule: data.get(#gravityRule, or: $value.gravityRule),
      name: data.get(#name, or: $value.name),
      owner: data.get(#owner, or: $value.owner));

  @override
  LobbyCopyWith<$R2, Lobby, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _LobbyCopyWithImpl($value, $cast, t);
}
