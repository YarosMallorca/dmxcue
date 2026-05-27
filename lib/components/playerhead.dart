import 'package:dmxcue/providers/playback.provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Playerhead extends ConsumerWidget {
  final int elapsedMs;
  final int totalMs;

  const Playerhead({super.key, required this.elapsedMs, required this.totalMs});

  void _seek(WidgetRef ref, double localX, double barWidth) {
    if (totalMs <= 0 || barWidth <= 0) return;
    final ratio = (localX / barWidth).clamp(0.0, 1.0);
    ref.read(playbackProvider.notifier).jumpTo((ratio * totalMs).round());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 12,
      children: [
        _TimeDisplay(timeMs: elapsedMs),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (d) => _seek(ref, d.localPosition.dx, barWidth),
                onHorizontalDragStart: (d) =>
                    _seek(ref, d.localPosition.dx, barWidth),
                onHorizontalDragUpdate: (d) =>
                    _seek(ref, d.localPosition.dx, barWidth),
                child: SizedBox(
                  height: 32,
                  child: Center(
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
                ),
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
