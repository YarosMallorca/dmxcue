import 'package:flutter/material.dart';

class Playerhead extends StatelessWidget {
  final int elapsedMs;
  final int totalMs;

  const Playerhead({super.key, required this.elapsedMs, required this.totalMs});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 12,
      children: [
        _TimeDisplay(timeMs: elapsedMs),
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 0.0,
              end: totalMs > 0 ? elapsedMs / totalMs : 0,
            ),
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.white12,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.lightBlue,
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              );
            },
          ),
        ),
        _TimeDisplay(timeMs: totalMs),
      ],
    );
  }
}

class _TimeDisplay extends StatelessWidget {
  final int timeMs;

  const _TimeDisplay({required this.timeMs});

  @override
  Widget build(BuildContext context) {
    final minutes = (timeMs ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((timeMs % 60000) ~/ 1000).toString().padLeft(2, '0');

    return Text(
      '$minutes:$seconds',
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }
}
