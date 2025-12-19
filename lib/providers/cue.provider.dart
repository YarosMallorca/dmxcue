import 'package:dmxcue/models/cue.dart';
import 'package:dmxcue/providers/playback.provider.dart';
import 'package:dmxcue/providers/songs.provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentCueProvider = Provider<Cue?>((ref) {
  final song = ref.watch(currentSongProvider);
  final elapsed = ref.watch(elapsedMsProvider);

  Cue? current;
  for (final cue in song.cues) {
    if (cue.timeMs <= elapsed) {
      current = cue;
    } else {
      break;
    }
  }
  return current;
});

final nextCueProvider = Provider<Cue?>((ref) {
  final song = ref.watch(currentSongProvider);
  final elapsed = ref.watch(elapsedMsProvider);

  for (final cue in song.cues) {
    if (cue.timeMs > elapsed) {
      return cue;
    }
  }
  return null;
});
