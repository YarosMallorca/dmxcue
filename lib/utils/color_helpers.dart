import 'package:flutter/material.dart';

final Map<String, Color> cueWordColors = {
  'RED': Colors.red,
  'ORANGE': Colors.orange,
  'YELLOW': Colors.yellow,
  'GREEN': Colors.green,
  'BLUE': Colors.blue,
  'PINK': Colors.pink,
  'PURPLE': Colors.purple,
  'WHITE': Colors.white,
  'UV': Colors.purple,
};

List<String> shaderWords = ['SPOT', 'CHASE', 'BLACKOUT'];

Shader getShaderForWord(String word, Rect bounds, Color fallbackColor) {
  final upper = word.toUpperCase();

  if (upper == 'SPOT') {
    return RadialGradient(
      colors: [
        const Color.fromARGB(255, 255, 243, 199),
        const Color.fromARGB(255, 255, 180, 104).withAlpha(100),
      ],
      center: Alignment.center,
      radius: 0.6,
    ).createShader(bounds);
  } else if (upper == 'CHASE') {
    return LinearGradient(
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.purple,
      ],
    ).createShader(bounds);
  } else if (upper == 'BLACKOUT') {
    return RadialGradient(
      colors: [
        const Color.fromARGB(255, 255, 0, 0),
        const Color.fromARGB(255, 129, 0, 0).withAlpha(100),
      ],
      center: Alignment.center,
      radius: 2,
    ).createShader(bounds);
  }

  // fallback: solid color
  return LinearGradient(
    colors: [fallbackColor, fallbackColor],
  ).createShader(bounds);
}
