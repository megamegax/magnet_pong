// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'paddle.dart';

class PaddleMapper extends ClassMapperBase<Paddle> {
  PaddleMapper._();

  static PaddleMapper? _instance;
  static PaddleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PaddleMapper._());
      PlayerMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Paddle';

  static Offset _$position(Paddle v) => v.position;
  static const Field<Paddle, Offset> _f$position =
      Field('position', _$position);
  static double _$width(Paddle v) => v.width;
  static const Field<Paddle, double> _f$width = Field('width', _$width);
  static double _$height(Paddle v) => v.height;
  static const Field<Paddle, double> _f$height = Field('height', _$height);
  static Player _$player(Paddle v) => v.player;
  static const Field<Paddle, Player> _f$player = Field('player', _$player);
  static double _$charge(Paddle v) => v.charge;
  static const Field<Paddle, double> _f$charge =
      Field('charge', _$charge, opt: true, def: 0);
  static Offset _$movementDelta(Paddle v) => v.movementDelta;
  static const Field<Paddle, Offset> _f$movementDelta =
      Field('movementDelta', _$movementDelta, opt: true, def: Offset.zero);

  @override
  final MappableFields<Paddle> fields = const {
    #position: _f$position,
    #width: _f$width,
    #height: _f$height,
    #player: _f$player,
    #charge: _f$charge,
    #movementDelta: _f$movementDelta,
  };

  static Paddle _instantiate(DecodingData data) {
    return Paddle(
        position: data.dec(_f$position),
        width: data.dec(_f$width),
        height: data.dec(_f$height),
        player: data.dec(_f$player),
        charge: data.dec(_f$charge),
        movementDelta: data.dec(_f$movementDelta));
  }

  @override
  final Function instantiate = _instantiate;

  static Paddle fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Paddle>(map);
  }

  static Paddle fromJson(String json) {
    return ensureInitialized().decodeJson<Paddle>(json);
  }
}

mixin PaddleMappable {
  String toJson() {
    return PaddleMapper.ensureInitialized().encodeJson<Paddle>(this as Paddle);
  }

  Map<String, dynamic> toMap() {
    return PaddleMapper.ensureInitialized().encodeMap<Paddle>(this as Paddle);
  }

  PaddleCopyWith<Paddle, Paddle, Paddle> get copyWith =>
      _PaddleCopyWithImpl(this as Paddle, $identity, $identity);
  @override
  String toString() {
    return PaddleMapper.ensureInitialized().stringifyValue(this as Paddle);
  }

  @override
  bool operator ==(Object other) {
    return PaddleMapper.ensureInitialized().equalsValue(this as Paddle, other);
  }

  @override
  int get hashCode {
    return PaddleMapper.ensureInitialized().hashValue(this as Paddle);
  }
}

extension PaddleValueCopy<$R, $Out> on ObjectCopyWith<$R, Paddle, $Out> {
  PaddleCopyWith<$R, Paddle, $Out> get $asPaddle =>
      $base.as((v, t, t2) => _PaddleCopyWithImpl(v, t, t2));
}

abstract class PaddleCopyWith<$R, $In extends Paddle, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PlayerCopyWith<$R, Player, Player> get player;
  $R call(
      {Offset? position,
      double? width,
      double? height,
      Player? player,
      double? charge,
      Offset? movementDelta});
  PaddleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PaddleCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Paddle, $Out>
    implements PaddleCopyWith<$R, Paddle, $Out> {
  _PaddleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Paddle> $mapper = PaddleMapper.ensureInitialized();
  @override
  PlayerCopyWith<$R, Player, Player> get player =>
      $value.player.copyWith.$chain((v) => call(player: v));
  @override
  $R call(
          {Offset? position,
          double? width,
          double? height,
          Player? player,
          double? charge,
          Offset? movementDelta}) =>
      $apply(FieldCopyWithData({
        if (position != null) #position: position,
        if (width != null) #width: width,
        if (height != null) #height: height,
        if (player != null) #player: player,
        if (charge != null) #charge: charge,
        if (movementDelta != null) #movementDelta: movementDelta
      }));
  @override
  Paddle $make(CopyWithData data) => Paddle(
      position: data.get(#position, or: $value.position),
      width: data.get(#width, or: $value.width),
      height: data.get(#height, or: $value.height),
      player: data.get(#player, or: $value.player),
      charge: data.get(#charge, or: $value.charge),
      movementDelta: data.get(#movementDelta, or: $value.movementDelta));

  @override
  PaddleCopyWith<$R2, Paddle, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PaddleCopyWithImpl($value, $cast, t);
}
