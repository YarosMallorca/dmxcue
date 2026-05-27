import 'package:dmxcue/models/song.dart';
import 'package:dmxcue/providers/show.provider.dart';
import 'package:dmxcue/providers/song_selection.provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final songsProvider = Provider<List<Song>>((ref) {
  final show = ref.watch(showProvider).requireValue;
  return show.songs;
});

final currentSongProvider = Provider<Song>((ref) {
  final songs = ref.watch(songsProvider);
  final index = ref.watch(songSelectionProvider).index;
  return songs[index];
});

final nextSongProvider = Provider<Song?>((ref) {
  final songs = ref.watch(songsProvider);
  final index = ref.watch(songSelectionProvider).index;
  if (index + 1 < songs.length) {
    return songs[index + 1];
  }
  return null;
});

final songProgressProvider = Provider<double>((ref) {
  final songs = ref.watch(songsProvider);
  final index = ref.watch(songSelectionProvider).index;

  if (songs.isEmpty) return 0.0;

  return (index + 1) / songs.length;
});
