// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'ball.dart';

class BallMapper extends ClassMapperBase<Ball> {
  BallMapper._();

  static BallMapper? _instance;
  static BallMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BallMapper._());
      MapperContainer.globals.useAll([OffsetMapper(), ColorMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'Ball';

  static Offset _$position(Ball v) => v.position;
  static const Field<Ball, Offset> _f$position = Field('position', _$position);
  static Offset _$velocity(Ball v) => v.velocity;
  static const Field<Ball, Offset> _f$velocity = Field('velocity', _$velocity);
  static double _$mass(Ball v) => v.mass;
  static const Field<Ball, double> _f$mass = Field('mass', _$mass);
  static Color _$color(Ball v) => v.color;
  static const Field<Ball, Color> _f$color = Field('color', _$color);

  @override
  final MappableFields<Ball> fields = const {
    #position: _f$position,
    #velocity: _f$velocity,
    #mass: _f$mass,
    #color: _f$color,
  };

  static Ball _instantiate(DecodingData data) {
    return Ball(
        position: data.dec(_f$position),
        velocity: data.dec(_f$velocity),
        mass: data.dec(_f$mass),
        color: data.dec(_f$color));
  }

  @override
  final Function instantiate = _instantiate;

  static Ball fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Ball>(map);
  }

  static Ball fromJson(String json) {
    return ensureInitialized().decodeJson<Ball>(json);
  }
}

mixin BallMappable {
  String toJson() {
    return BallMapper.ensureInitialized().encodeJson<Ball>(this as Ball);
  }

  Map<String, dynamic> toMap() {
    return BallMapper.ensureInitialized().encodeMap<Ball>(this as Ball);
  }

  BallCopyWith<Ball, Ball, Ball> get copyWith =>
      _BallCopyWithImpl(this as Ball, $identity, $identity);
  @override
  String toString() {
    return BallMapper.ensureInitialized().stringifyValue(this as Ball);
  }

  @override
  bool operator ==(Object other) {
    return BallMapper.ensureInitialized().equalsValue(this as Ball, other);
  }

  @override
  int get hashCode {
    return BallMapper.ensureInitialized().hashValue(this as Ball);
  }
}

extension BallValueCopy<$R, $Out> on ObjectCopyWith<$R, Ball, $Out> {
  BallCopyWith<$R, Ball, $Out> get $asBall =>
      $base.as((v, t, t2) => _BallCopyWithImpl(v, t, t2));
}

abstract class BallCopyWith<$R, $In extends Ball, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Offset? position, Offset? velocity, double? mass, Color? color});
  BallCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BallCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Ball, $Out>
    implements BallCopyWith<$R, Ball, $Out> {
  _BallCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Ball> $mapper = BallMapper.ensureInitialized();
  @override
  $R call({Offset? position, Offset? velocity, double? mass, Color? color}) =>
      $apply(FieldCopyWithData({
        if (position != null) #position: position,
        if (velocity != null) #velocity: velocity,
        if (mass != null) #mass: mass,
        if (color != null) #color: color
      }));
  @override
  Ball $make(CopyWithData data) => Ball(
      position: data.get(#position, or: $value.position),
      velocity: data.get(#velocity, or: $value.velocity),
      mass: data.get(#mass, or: $value.mass),
      color: data.get(#color, or: $value.color));

  @override
  BallCopyWith<$R2, Ball, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _BallCopyWithImpl($value, $cast, t);
}
