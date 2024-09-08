import 'package:flutter/material.dart';

class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  double horizontalPadding;
  double verticalPadding;
  double fontSize;

  NeonButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.horizontalPadding = 40,
      this.verticalPadding = 20,
      this.fontSize = 20});

  @override
  Widget build(BuildContext context) {
    return _buildNeonButton(context, text, onPressed: onPressed);
  }

  Widget _buildNeonButton(BuildContext context, String text,
      {required VoidCallback onPressed}) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primaryContainer,
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        shadowColor: theme.colorScheme.primary,
        elevation: 20,
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontSize: fontSize,
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
    );
  }
}
