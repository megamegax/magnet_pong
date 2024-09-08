import 'package:dart_mappable/dart_mappable.dart';
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

class ColorMapper extends SimpleMapper<Color> {
  const ColorMapper();

  @override
  Color decode(dynamic value) {
    return Color(value);
  }

  @override
  dynamic encode(Color self) {
    return self.value;
  }
}

class MaterialColorMapper extends SimpleMapper<MaterialColor> {
  const MaterialColorMapper();

  @override
  MaterialColor decode(dynamic value) {
    return MaterialColor(value, {
      50: Color(value),
      100: Color(value),
      200: Color(value),
      300: Color(value),
      400: Color(value),
      500: Color(value),
      600: Color(value),
      700: Color(value),
      800: Color(value),
      900: Color(value),
    });
  }

  @override
  dynamic encode(MaterialColor self) {
    return self.value;
  }
}
