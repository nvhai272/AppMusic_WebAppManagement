import 'package:flutter/material.dart';

class Colours {
  static Color _defaultColor = Colors.red;
  static final Map<ColorsEnum, Color> _colorMapping = {
    ColorsEnum.RED: Colors.red,
    ColorsEnum.GREEN: Colors.green,
    ColorsEnum.BLUE: Colors.blue,
    ColorsEnum.BLACK: Colors.black,
    ColorsEnum.YELLOW: Colors.yellow,
    ColorsEnum.BROWN: Colors.brown,
    ColorsEnum.PURPLE: Colors.purple,
    ColorsEnum.PINK: Colors.pink,
  };

  static Color getColourFromString(String cl) {
    var op = ColorsEnum.values.where((it) => it.name == cl);
    if (op.isEmpty) {
      return _defaultColor;
    }

    return getColour(op.first);
  }

  static Color getColour(ColorsEnum cl) {
    var color = _colorMapping[cl];

    if (color == null) {
      return _defaultColor;
    }

    return color;
  }
}

enum ColorsEnum { RED, GREEN, BLUE, BLACK, YELLOW, BROWN, PURPLE, PINK }
