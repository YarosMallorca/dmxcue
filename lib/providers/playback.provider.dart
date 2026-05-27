import 'package:dmxcue/providers/song_selection.provider.dart';
import 'package:dmxcue/providers/songs.provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlaybackState {
  final bool isPlaying;
  final int elapsedMs;

  const PlaybackState({required this.isPlaying, required this.elapsedMs});

  PlaybackState copyWith({bool? isPlaying, int? elapsedMs}) {
    return PlaybackState(
      isPlaying: isPlaying ?? this.isPlaying,
      elapsedMs: elapsedMs ?? this.elapsedMs,
    );
  }
}

final playbackProvider = NotifierProvider<PlaybackNotifier, PlaybackState>(
  PlaybackNotifier.new,
);

class PlaybackNotifier extends Notifier<PlaybackState> {
  Stopwatch? _stopwatch;
  int _offsetMs = 0;

  @override
  PlaybackState build() {
    return const PlaybackState(isPlaying: false, elapsedMs: 0);
  }

  void play() {
    _stopwatch ??= Stopwatch();
    _stopwatch!
      ..reset()
      ..start();

    _offsetMs = state.elapsedMs;

    state = state.copyWith(isPlaying: true);
  }

  void pause() {
    _stopwatch?.stop();
    state = state.copyWith(isPlaying: false);
  }

  void stop() {
    _stopwatch?.stop();
    _stopwatch = null;
    _offsetMs = 0;
    state = const PlaybackState(isPlaying: false, elapsedMs: 0);
  }

  void tick() {
    if (!(_stopwatch?.isRunning ?? false)) return;

    final elapsed = _offsetMs + _stopwatch!.elapsedMilliseconds;
    final song = ref.read(currentSongProvider);

    if (elapsed >= song.durationMs) {
      _stopwatch?.stop();
      if (ref.watch(songsProvider).length ==
          ref.watch(songSelectionProvider).index + 1) {
        state = state.copyWith(isPlaying: false, elapsedMs: song.durationMs);
      } else {
        state = state.copyWith(isPlaying: false, elapsedMs: 0);
      }

      ref
          .read(songSelectionProvider.notifier)
          .next(ref.read(songsProvider).length);

      return;
    }

    state = state.copyWith(elapsedMs: elapsed);
  }

  void jumpTo(int timeMs) {
    _offsetMs = timeMs;

    if (state.isPlaying) {
      _stopwatch ??= Stopwatch();
      _stopwatch!
        ..reset()
        ..start();
    }

    state = PlaybackState(isPlaying: state.isPlaying, elapsedMs: timeMs);
  }
}

final elapsedMsProvider = Provider<int>((ref) {
  return ref.watch(playbackProvider).elapsedMs;
});

final elapsedSecondsProvider = Provider<int>((ref) {
  final elapsedMs = ref.watch(elapsedMsProvider);
  return elapsedMs ~/ 1000;
});

final formattedElapsedTimeProvider = Provider<String>((ref) {
  final elapsedMs = ref.watch(elapsedMsProvider);
  final minutes = (elapsedMs ~/ 60000).toString().padLeft(2, '0');
  final seconds = ((elapsedMs % 60000) ~/ 1000).toString().padLeft(2, '0');
  return '$minutes:$seconds';
});
