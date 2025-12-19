import 'package:dmxcue/providers/playback.provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlaybackControls extends ConsumerWidget {
  const PlaybackControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playback = ref.watch(playbackProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.deepPurple.shade900,
            ),
            child: IconButton(
              icon: const Icon(Icons.replay, color: Colors.white),
              iconSize: 40,
              onPressed: () => ref.read(playbackProvider.notifier).stop(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.blue.shade900,
            ),
            child: IconButton(
              icon: Icon(
                playback.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              iconSize: 86,
              color: Colors.white,
              onPressed: () {
                final notifier = ref.read(playbackProvider.notifier);
                playback.isPlaying ? notifier.pause() : notifier.play();
              },
            ),
          ),
        ),
      ],
    );
  }
}
