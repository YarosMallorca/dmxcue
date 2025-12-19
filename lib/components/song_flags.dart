import 'package:flutter/material.dart';

class SongFlags extends StatelessWidget {
  final List<String> flags;

  const SongFlags({super.key, required this.flags});

  @override
  Widget build(BuildContext context) {
    if (flags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: flags
          .map(
            (f) => Chip(
              label: Text(
                f.startsWith('!!') ? f.substring(2) : f,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: f.startsWith('!!') ? 32 : 26,
                ),
              ),
              backgroundColor: f.startsWith('!!')
                  ? Colors.red.shade900.withAlpha(200)
                  : Colors.white12,

              labelStyle: const TextStyle(color: Colors.white),
            ),
          )
          .toList(),
    );
  }
}
