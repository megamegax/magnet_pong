// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'game_state.dart';

class GameStateMapper extends ClassMapperBase<GameState> {
  GameStateMapper._();

  static GameStateMapper? _instance;
  static GameStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GameStateMapper._());
      MapperContainer.globals.useAll([SizeMapper()]);
      PlayerPositionMapper.ensureInitialized();
      PaddleMapper.ensureInitialized();
      BallMapper.ensureInitialized();
      PlayerMapper.ensureInitialized();
      GravityRuleMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'GameState';

  static Map<PlayerPosition, Paddle> _$paddles(GameState v) => v.paddles;
  static const Field<GameState, Map<PlayerPosition, Paddle>> _f$paddles =
      Field('paddles', _$paddles);
  static List<Ball> _$balls(GameState v) => v.balls;
  static const Field<GameState, List<Ball>> _f$balls = Field('balls', _$balls);
  static Player _$currentPlayer(GameState v) => v.currentPlayer;
  static const Field<GameState, Player> _f$currentPlayer =
      Field('currentPlayer', _$currentPlayer);
  static List<Player> _$activePlayers(GameState v) => v.activePlayers;
  static const Field<GameState, List<Player>> _f$activePlayers =
      Field('activePlayers', _$activePlayers);
  static double _$rotationX(GameState v) => v.rotationX;
  static const Field<GameState, double> _f$rotationX =
      Field('rotationX', _$rotationX);
  static double _$rotationY(GameState v) => v.rotationY;
  static const Field<GameState, double> _f$rotationY =
      Field('rotationY', _$rotationY);
  static GravityRule _$gravityRule(GameState v) => v.gravityRule;
  static const Field<GameState, GravityRule> _f$gravityRule =
      Field('gravityRule', _$gravityRule);
  static Size _$fieldSize(GameState v) => v.fieldSize;
  static const Field<GameState, Size> _f$fieldSize =
      Field('fieldSize', _$fieldSize);
  static Map<PlayerPosition, double> _$lives(GameState v) => v.lives;
  static const Field<GameState, Map<PlayerPosition, double>> _f$lives =
      Field('lives', _$lives);
  static bool _$isGameOver(GameState v) => v.isGameOver;
  static const Field<GameState, bool> _f$isGameOver =
      Field('isGameOver', _$isGameOver, opt: true, def: false);
  static String? _$winnerName(GameState v) => v.winnerName;
  static const Field<GameState, String> _f$winnerName =
      Field('winnerName', _$winnerName, opt: true);

  @override
  final MappableFields<GameState> fields = const {
    #paddles: _f$paddles,
    #balls: _f$balls,
    #currentPlayer: _f$currentPlayer,
    #activePlayers: _f$activePlayers,
    #rotationX: _f$rotationX,
    #rotationY: _f$rotationY,
    #gravityRule: _f$gravityRule,
    #fieldSize: _f$fieldSize,
    #lives: _f$lives,
    #isGameOver: _f$isGameOver,
    #winnerName: _f$winnerName,
  };

  static GameState _instantiate(DecodingData data) {
    return GameState(
        paddles: data.dec(_f$paddles),
        balls: data.dec(_f$balls),
        currentPlayer: data.dec(_f$currentPlayer),
        activePlayers: data.dec(_f$activePlayers),
        rotationX: data.dec(_f$rotationX),
        rotationY: data.dec(_f$rotationY),
        gravityRule: data.dec(_f$gravityRule),
        fieldSize: data.dec(_f$fieldSize),
        lives: data.dec(_f$lives),
        isGameOver: data.dec(_f$isGameOver),
        winnerName: data.dec(_f$winnerName));
  }

  @override
  final Function instantiate = _instantiate;

  static GameState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<GameState>(map);
  }

  static GameState fromJson(String json) {
    return ensureInitialized().decodeJson<GameState>(json);
  }
}

mixin GameStateMappable {
  String toJson() {
    return GameStateMapper.ensureInitialized()
        .encodeJson<GameState>(this as GameState);
  }

  Map<String, dynamic> toMap() {
    return GameStateMapper.ensureInitialized()
        .encodeMap<GameState>(this as GameState);
  }

  GameStateCopyWith<GameState, GameState, GameState> get copyWith =>
      _GameStateCopyWithImpl(this as GameState, $identity, $identity);
  @override
  String toString() {
    return GameStateMapper.ensureInitialized()
        .stringifyValue(this as GameState);
  }

  @override
  bool operator ==(Object other) {
    return GameStateMapper.ensureInitialized()
        .equalsValue(this as GameState, other);
  }

  @override
  int get hashCode {
    return GameStateMapper.ensureInitialized().hashValue(this as GameState);
  }
}

extension GameStateValueCopy<$R, $Out> on ObjectCopyWith<$R, GameState, $Out> {
  GameStateCopyWith<$R, GameState, $Out> get $asGameState =>
      $base.as((v, t, t2) => _GameStateCopyWithImpl(v, t, t2));
}

abstract class GameStateCopyWith<$R, $In extends GameState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, PlayerPosition, Paddle, PaddleCopyWith<$R, Paddle, Paddle>>
      get paddles;
  ListCopyWith<$R, Ball, BallCopyWith<$R, Ball, Ball>> get balls;
  PlayerCopyWith<$R, Player, Player> get currentPlayer;
  ListCopyWith<$R, Player, PlayerCopyWith<$R, Player, Player>>
      get activePlayers;
  MapCopyWith<$R, PlayerPosition, double, ObjectCopyWith<$R, double, double>>
      get lives;
  $R call(
      {Map<PlayerPosition, Paddle>? paddles,
      List<Ball>? balls,
      Player? currentPlayer,
      List<Player>? activePlayers,
      double? rotationX,
      double? rotationY,
      GravityRule? gravityRule,
      Size? fieldSize,
      Map<PlayerPosition, double>? lives,
      bool? isGameOver,
      String? winnerName});
  GameStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _GameStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GameState, $Out>
    implements GameStateCopyWith<$R, GameState, $Out> {
  _GameStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<GameState> $mapper =
      GameStateMapper.ensureInitialized();
  @override
  MapCopyWith<$R, PlayerPosition, Paddle, PaddleCopyWith<$R, Paddle, Paddle>>
      get paddles => MapCopyWith($value.paddles, (v, t) => v.copyWith.$chain(t),
          (v) => call(paddles: v));
  @override
  ListCopyWith<$R, Ball, BallCopyWith<$R, Ball, Ball>> get balls =>
      ListCopyWith(
          $value.balls, (v, t) => v.copyWith.$chain(t), (v) => call(balls: v));
  @override
  PlayerCopyWith<$R, Player, Player> get currentPlayer =>
      $value.currentPlayer.copyWith.$chain((v) => call(currentPlayer: v));
  @override
  ListCopyWith<$R, Player, PlayerCopyWith<$R, Player, Player>>
      get activePlayers => ListCopyWith($value.activePlayers,
          (v, t) => v.copyWith.$chain(t), (v) => call(activePlayers: v));
  @override
  MapCopyWith<$R, PlayerPosition, double, ObjectCopyWith<$R, double, double>>
      get lives => MapCopyWith($value.lives,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(lives: v));
  @override
  $R call(
          {Map<PlayerPosition, Paddle>? paddles,
          List<Ball>? balls,
          Player? currentPlayer,
          List<Player>? activePlayers,
          double? rotationX,
          double? rotationY,
          GravityRule? gravityRule,
          Size? fieldSize,
          Map<PlayerPosition, double>? lives,
          bool? isGameOver,
          Object? winnerName = $none}) =>
      $apply(FieldCopyWithData({
        if (paddles != null) #paddles: paddles,
        if (balls != null) #balls: balls,
        if (currentPlayer != null) #currentPlayer: currentPlayer,
        if (activePlayers != null) #activePlayers: activePlayers,
        if (rotationX != null) #rotationX: rotationX,
        if (rotationY != null) #rotationY: rotationY,
        if (gravityRule != null) #gravityRule: gravityRule,
        if (fieldSize != null) #fieldSize: fieldSize,
        if (lives != null) #lives: lives,
        if (isGameOver != null) #isGameOver: isGameOver,
        if (winnerName != $none) #winnerName: winnerName
      }));
  @override
  GameState $make(CopyWithData data) => GameState(
      paddles: data.get(#paddles, or: $value.paddles),
      balls: data.get(#balls, or: $value.balls),
      currentPlayer: data.get(#currentPlayer, or: $value.currentPlayer),
      activePlayers: data.get(#activePlayers, or: $value.activePlayers),
      rotationX: data.get(#rotationX, or: $value.rotationX),
      rotationY: data.get(#rotationY, or: $value.rotationY),
      gravityRule: data.get(#gravityRule, or: $value.gravityRule),
      fieldSize: data.get(#fieldSize, or: $value.fieldSize),
      lives: data.get(#lives, or: $value.lives),
      isGameOver: data.get(#isGameOver, or: $value.isGameOver),
      winnerName: data.get(#winnerName, or: $value.winnerName));

  @override
  GameStateCopyWith<$R2, GameState, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _GameStateCopyWithImpl($value, $cast, t);
}
