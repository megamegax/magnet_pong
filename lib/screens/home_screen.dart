import 'package:flutter/material.dart';
import 'package:magnet_pong/screens/lobby_screen.dart';
import 'package:magnet_pong/screens/settings_screen.dart';
import 'package:magnet_pong/widgets/neon_button.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

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
              'Magnet Pong',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontSize: 50,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: theme.colorScheme.primary,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            NeonButton(
                text: 'Start Game',
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LobbyScreen()));
                }),
            const SizedBox(height: 20),
            NeonButton(
                text: 'Settings',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsScreen()));
                }),
            const SizedBox(height: 20),
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
