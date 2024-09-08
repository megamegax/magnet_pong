import 'package:flutter/material.dart';

class NeonText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const NeonText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return _buildNeonText(context, text, style);
  }

  Widget _buildNeonText(BuildContext context, String text, TextStyle? style) {
    final theme = Theme.of(context);
    final textStyle = style ?? theme.textTheme.bodyLarge;
    return Text(
      text,
      style: textStyle?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 20.0,
            color: theme.colorScheme.primary,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }
}
