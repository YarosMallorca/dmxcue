import 'package:dmxcue/models/song.dart';
import 'package:dmxcue/providers/playback.provider.dart';
import 'package:dmxcue/providers/song_selection.provider.dart';
import 'package:dmxcue/providers/songs.provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TopBar extends ConsumerWidget {
  final Song song;

  const TopBar({super.key, required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        Row(
          spacing: 12,
          children: [
            Text(
              (ref.watch(songSelectionProvider).index + 1).toString(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0.0,
                  end: ref.watch(songProgressProvider),
                ),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.white12,
                    minHeight: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.tealAccent,
                    ),
                  );
                },
              ),
            ),
            Text(
              ref.watch(songsProvider).length.toString(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.teal.shade900,
              ),
              child: IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                iconSize: 48,
                onPressed: () {
                  ref.read(playbackProvider.notifier).stop();
                  ref.read(songSelectionProvider.notifier).previous();
                },
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    song.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (song.artist != null)
                    Text(
                      song.artist!,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.teal.shade900,
              ),
              child: IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                iconSize: 48,
                onPressed: () {
                  ref.read(playbackProvider.notifier).stop();
                  ref
                      .read(songSelectionProvider.notifier)
                      .next(ref.read(songsProvider).length);
                },
              ),
            ),
          ],
        ),
        if (song.notes != null)
          Text(
            song.notes!.startsWith('!!')
                ? song.notes!.substring(2)
                : song.notes!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: song.notes!.startsWith('!!') ? Colors.red : Colors.white70,
              fontWeight: song.notes!.startsWith('!!')
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: song.notes!.startsWith('!!') ? 32 : 24,
            ),
          ),
      ],
    );
  }
}
