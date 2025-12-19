import 'package:dmxcue/utils/color_helpers.dart';
import 'package:flutter/material.dart';

class ColoredText extends StatelessWidget {
  final String text;
  final TextStyle baseStyle;
  final TextAlign textAlign;

  const ColoredText(
    this.text, {
    super.key,
    required this.baseStyle,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final matches = RegExp(r'\n|[^\s\n]+|\s+').allMatches(text);

    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: matches.map((m) {
          final word = m.group(0)!;

          // Preserve line breaks
          if (word == '\n') {
            return const TextSpan(text: '\n');
          }

          final cleanWord = word.replaceAll(RegExp(r'[^A-Za-z]'), '');
          final upper = cleanWord.toUpperCase();

          final color = cueWordColors[upper] ?? baseStyle.color;
          final textSpanStyle = baseStyle.copyWith(color: color);

          if (shaderWords.contains(upper)) {
            return WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    getShaderForWord(upper, bounds, color!),
                blendMode: BlendMode.srcIn,
                child: Text(word, style: textSpanStyle),
              ),
            );
          }

          // normal words: plain TextSpan
          return TextSpan(text: word, style: textSpanStyle);
        }).toList(),
      ),
    );
  }
}
