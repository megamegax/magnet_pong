import 'package:flutter/material.dart';

var colorIndex = 0;

Color getNextColor(BuildContext context) {
  colorIndex++;
  switch (colorIndex % 4) {
    case 0:
      return Theme.of(context).colorScheme.tertiary;
    case 1:
      return Theme.of(context).colorScheme.primary;
    case 2:
      return Theme.of(context).colorScheme.error;
    case 3:
      return Theme.of(context).colorScheme.secondary;
    default:
      return Theme.of(context).colorScheme.error;
  }
}

resetColors() {
  colorIndex = 0;
}
