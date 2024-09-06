import 'package:flutter/material.dart';
import 'package:gravity_pong/screens/lobby_screen.dart';
import 'package:gravity_pong/screens/settings_screen.dart';
import 'package:gravity_pong/widgets/neon_button.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Gravity Pong',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 50,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: theme.colorScheme.primary,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            NeonButton(
                text: 'Start Game',
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LobbyScreen()));
                }),
            SizedBox(height: 20),
            NeonButton(
                text: 'Settings',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsScreen()));
                }),
            SizedBox(height: 20),
            NeonButton(
                text: 'Exit',
                onPressed: () {
                  // Kilépés logika
                }),
          ],
        ),
      ),
    );
  }
}
