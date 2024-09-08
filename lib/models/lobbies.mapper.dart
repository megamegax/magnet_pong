// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'lobbies.dart';

class LobbiesMapper extends ClassMapperBase<Lobbies> {
  LobbiesMapper._();

  static LobbiesMapper? _instance;
  static LobbiesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LobbiesMapper._());
      LobbyMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Lobbies';

  static List<Lobby> _$lobbies(Lobbies v) => v.lobbies;
  static const Field<Lobbies, List<Lobby>> _f$lobbies =
      Field('lobbies', _$lobbies);

  @override
  final MappableFields<Lobbies> fields = const {
    #lobbies: _f$lobbies,
  };

  static Lobbies _instantiate(DecodingData data) {
    return Lobbies(data.dec(_f$lobbies));
  }

  @override
  final Function instantiate = _instantiate;

  static Lobbies fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Lobbies>(map);
  }

  static Lobbies fromJson(String json) {
    return ensureInitialized().decodeJson<Lobbies>(json);
  }
}

mixin LobbiesMappable {
  String toJson() {
    return LobbiesMapper.ensureInitialized()
        .encodeJson<Lobbies>(this as Lobbies);
  }

  Map<String, dynamic> toMap() {
    return LobbiesMapper.ensureInitialized()
        .encodeMap<Lobbies>(this as Lobbies);
  }

  LobbiesCopyWith<Lobbies, Lobbies, Lobbies> get copyWith =>
      _LobbiesCopyWithImpl(this as Lobbies, $identity, $identity);
  @override
  String toString() {
    return LobbiesMapper.ensureInitialized().stringifyValue(this as Lobbies);
  }

  @override
  bool operator ==(Object other) {
    return LobbiesMapper.ensureInitialized()
        .equalsValue(this as Lobbies, other);
  }

  @override
  int get hashCode {
    return LobbiesMapper.ensureInitialized().hashValue(this as Lobbies);
  }
}

extension LobbiesValueCopy<$R, $Out> on ObjectCopyWith<$R, Lobbies, $Out> {
  LobbiesCopyWith<$R, Lobbies, $Out> get $asLobbies =>
      $base.as((v, t, t2) => _LobbiesCopyWithImpl(v, t, t2));
}

abstract class LobbiesCopyWith<$R, $In extends Lobbies, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Lobby, LobbyCopyWith<$R, Lobby, Lobby>> get lobbies;
  $R call({List<Lobby>? lobbies});
  LobbiesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LobbiesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Lobbies, $Out>
    implements LobbiesCopyWith<$R, Lobbies, $Out> {
  _LobbiesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Lobbies> $mapper =
      LobbiesMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Lobby, LobbyCopyWith<$R, Lobby, Lobby>> get lobbies =>
      ListCopyWith($value.lobbies, (v, t) => v.copyWith.$chain(t),
          (v) => call(lobbies: v));
  @override
  $R call({List<Lobby>? lobbies}) =>
      $apply(FieldCopyWithData({if (lobbies != null) #lobbies: lobbies}));
  @override
  Lobbies $make(CopyWithData data) =>
      Lobbies(data.get(#lobbies, or: $value.lobbies));

  @override
  LobbiesCopyWith<$R2, Lobbies, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _LobbiesCopyWithImpl($value, $cast, t);
}
