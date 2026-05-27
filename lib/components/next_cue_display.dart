import 'package:dmxcue/components/colored_text.dart';
import 'package:dmxcue/models/cue.dart';
import 'package:dmxcue/utils/show_helpers.dart';
import 'package:flutter/material.dart';

class NextSongFirstCueDisplay extends StatelessWidget {
  final String songTitle;
  final Cue firstCue;

  const NextSongFirstCueDisplay({
    super.key,
    required this.songTitle,
    required this.firstCue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.teal.withAlpha(25),
        border: Border.all(color: Colors.teal.withAlpha(70), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.teal.shade800,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'NEXT SONG',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                songTitle,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '@ ${formatTime(firstCue.timeMs)}',
            style: const TextStyle(color: Colors.white38, fontSize: 18),
          ),
          const SizedBox(height: 4),
          ColoredText(
            firstCue.label,
            baseStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white60,
            ),
            textAlign: TextAlign.center,
          ),
          if (firstCue.comment != null && firstCue.comment!.isNotEmpty) ...[
            const SizedBox(height: 6),
            ColoredText(
              firstCue.comment!,
              baseStyle: const TextStyle(
                color: Colors.white38,
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class NextCueDisplay extends StatefulWidget {
  final Cue? cue;
  final Cue? currentCue;
  final int currentMs;

  const NextCueDisplay({
    super.key,
    required this.cue,
    this.currentCue,
    required this.currentMs,
  });

  @override
  State<NextCueDisplay> createState() => _NextCueDisplayState();
}

class _NextCueDisplayState extends State<NextCueDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _backgroundColorAnimation =
        ColorTween(
          begin: Colors.white12,
          end: Colors.red.withAlpha(100),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void didUpdateWidget(NextCueDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cue != oldWidget.cue ||
        widget.currentCue != oldWidget.currentCue ||
        widget.currentMs != oldWidget.currentMs) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    if (widget.cue == null) return;

    final remainingMs = widget.cue!.timeMs - widget.currentMs;
    final remainingSec = (remainingMs / 1000).ceil();

    if (remainingSec <= 3 && remainingSec > 0) {
      if (!_animationController.isAnimating) {
        _animationController.repeat(reverse: true);
      }
    } else {
      if (_animationController.isAnimating) {
        _animationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cue == null) return const SizedBox.shrink();

    final remainingMs = widget.cue!.timeMs - widget.currentMs;
    final remainingSec = (remainingMs / 1000).ceil();
    final isCountdown = remainingSec <= 3 && remainingSec > 0;

    // Calculate progress for the progress bar
    final startMs = widget.currentCue?.timeMs ?? 0;
    final totalDurationMs = widget.cue!.timeMs - startMs;
    final elapsedMs = widget.currentMs - startMs;
    final progress = totalDurationMs > 0
        ? (elapsedMs / totalDurationMs).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isCountdown ? null : Colors.grey.withAlpha(30),
      ),
      child: Column(
        children: [
          // Add the progress bar
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: progress),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey.withAlpha(50),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              );
            },
          ),
          SizedBox(
            width: double.infinity,
            child: isCountdown
                ? _CountdownContent(
                    remainingSec: remainingSec,
                    cueLabel: widget.cue!.label,
                    cueComment: widget.cue!.comment,
                    backgroundAnimation: _backgroundColorAnimation,
                  )
                : _NormalContent(cue: widget.cue!, remainingSec: remainingSec),
          ),
        ],
      ),
    );
  }
}

class _CountdownContent extends StatelessWidget {
  final int remainingSec;
  final String cueLabel;
  final String? cueComment;
  final Animation<Color?> backgroundAnimation;

  const _CountdownContent({
    required this.remainingSec,
    required this.cueLabel,
    required this.cueComment,
    required this.backgroundAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: backgroundAnimation.value,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                remainingSec.toString(),
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              ColoredText(
                cueLabel,
                baseStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (cueComment != null) ...[
                const SizedBox(height: 8),
                ColoredText(
                  cueComment!,
                  baseStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _NormalContent extends StatelessWidget {
  final Cue cue;
  final int remainingSec;

  const _NormalContent({required this.cue, required this.remainingSec});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Next @ ${formatTime(cue.timeMs)}  (+${remainingSec}s)',
            style: const TextStyle(color: Colors.white54, fontSize: 24),
          ),
          const SizedBox(height: 4),
          ColoredText(
            cue.label,
            baseStyle: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          if (cue.comment != null) ...[
            const SizedBox(height: 8),
            ColoredText(
              cue.comment!,
              baseStyle: TextStyle(
                color: Colors.white70,
                fontSize: 25,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
