import 'package:dmxcue/components/colored_text.dart';
import 'package:dmxcue/models/cue.dart';
import 'package:dmxcue/utils/show_helpers.dart';
import 'package:flutter/material.dart';

class CurrentCueDisplay extends StatelessWidget {
  final Cue? cue;

  const CurrentCueDisplay({super.key, required this.cue});

  @override
  Widget build(BuildContext context) {
    if (cue == null) {
      return const Center(
        child: Text('—', style: TextStyle(color: Colors.white38, fontSize: 32)),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '@ ${formatTime(cue!.timeMs)}',
            style: const TextStyle(color: Colors.white54, fontSize: 32),
          ),
          const SizedBox(height: 8),
          ColoredText(
            cue!.label,
            baseStyle: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (cue!.comment != null) ...[
            const SizedBox(height: 8),
            ColoredText(
              cue!.comment!,
              baseStyle: TextStyle(
                color: Colors.white70,
                fontSize: 46,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
