import 'package:flutter/material.dart';
import 'package:magnet_pong/models/player_position.dart';
import '../state/game_state.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class GamePainter extends CustomPainter {
  final GameState gameState;
  final BuildContext context;
  GamePainter(this.gameState, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final theme = Theme.of(context);

    if (gameState.isGameOver) {
      _drawWinnerMessage(canvas, size, gameState.winnerName!, theme);
      return;
    }

    // Háttér szín a témából
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = theme.colorScheme.surface);

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2); // Középpont
    final matrix = vector.Matrix4.identity()
      ..rotateX(gameState.rotationX)
      ..rotateY(gameState.rotationY);

    // Alkalmazzuk a 3D transzformációt
    canvas.transform(matrix.storage);
    canvas.translate(-size.width / 2, -size.height / 2); // Vissza a helyére

    // Veszélyzónák kiszámítása és megjelenítése
    _drawDangerZones(canvas, size, theme);

    // Pálya határainak kirajzolása neonhatással
    _drawNeonRect(
      canvas,
      Rect.fromLTWH(0, 0, size.width, size.height),
      theme.colorScheme.primary,
      10.0,
    );

    // Paddle-k kirajzolása neonhatással
    for (var paddle in gameState.paddles.values) {
      _drawNeonRect(
        canvas,
        paddle.rect,
        paddle.player.color, // A játékos saját színe
        10.0,
        radius: Radius.circular(paddle.rect.height / 2),
      );
    }

    // Labda kirajzolása neonhatással
    for (var ball in gameState.balls) {
      _drawNeonCircle(
        canvas,
        ball.position,
        ball.radius,
        ball.color, // A labda színe
        15.0,
      );
    }

    canvas.restore(); // Eredeti állapot visszaállítása
  }

  void _drawDangerZones(Canvas canvas, Size size, ThemeData theme) {
    final double dangerZoneWidth =
        size.shortestSide / 1.5; // Veszélyzóna szélessége
    final double dangerZoneHeight =
        size.shortestSide / 1.5; // Veszélyzóna magassága

    // Bal oldali veszélyzóna
    if (gameState.paddles.containsKey(PlayerPosition.left)) {
      _drawNeonRect(
        canvas,
        Rect.fromLTWH(
            0, (size.height - dangerZoneHeight) / 2, 40, dangerZoneHeight),
        gameState.paddles[PlayerPosition.left]!.player.color,
        10.0,
      );
    }

    // Jobb oldali veszélyzóna
    if (gameState.paddles.containsKey(PlayerPosition.right)) {
      _drawNeonRect(
        canvas,
        Rect.fromLTWH(size.width - 40, (size.height - dangerZoneHeight) / 2, 40,
            dangerZoneHeight),
        gameState.paddles[PlayerPosition.right]!.player.color,
        10.0,
      );
    }

    // Felső veszélyzóna
    if (gameState.paddles.containsKey(PlayerPosition.top)) {
      _drawNeonRect(
        canvas,
        Rect.fromLTWH(
            (size.width - dangerZoneWidth) / 2, 0, dangerZoneWidth, 40),
        gameState.paddles[PlayerPosition.top]!.player.color,
        10.0,
      );
    }

    // Alsó veszélyzóna
    if (gameState.paddles.containsKey(PlayerPosition.bottom)) {
      _drawNeonRect(
        canvas,
        Rect.fromLTWH((size.width - dangerZoneWidth) / 2, size.height - 40,
            dangerZoneWidth, 40),
        gameState.paddles[PlayerPosition.bottom]!.player.color,
        10.0,
      );
    }
  }

  void _drawNeonRect(Canvas canvas, Rect rect, Color color, double blurRadius,
      {Radius? radius}) {
    final shadowPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);
    final neonPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    if (radius != null) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, radius), shadowPaint); // Árnyék
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, radius), neonPaint); // Neon
    } else {
      canvas.drawRect(rect, shadowPaint); // Árnyék
      canvas.drawRect(rect, neonPaint); // Neon
    }
  }

  void _drawNeonCircle(Canvas canvas, Offset center, double radius, Color color,
      double blurRadius) {
    final shadowPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);
    final neonPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, shadowPaint); // Árnyék
    canvas.drawCircle(center, radius, neonPaint); // Neon
  }

  void _drawWinnerMessage(
      Canvas canvas, Size size, String winnerName, ThemeData theme) {
    final textStyle = theme.textTheme.headlineLarge?.copyWith(
      color: theme.colorScheme.onSurface,
      shadows: [
        Shadow(
          blurRadius: 10.0,
          color: theme.colorScheme.primary,
          offset: const Offset(0, 0),
        ),
      ],
    );

    final textSpan = TextSpan(
      text: '$winnerName győzött!',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
