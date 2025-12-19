import 'package:dmxcue/providers/playback.provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StopwatchDisplay extends ConsumerWidget {
  final int? ms; // Make optional to allow using provider

  const StopwatchDisplay({super.key, this.ms});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeString = ms != null
        ? _formatTime(ms!)
        : ref.watch(formattedElapsedTimeProvider);

    return Center(
      child: Text(
        timeString,
        style: const TextStyle(
          color: Colors.lightBlue,
          fontSize: 82,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  static String _formatTime(int ms) {
    final minutes = (ms ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((ms % 60000) ~/ 1000).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
