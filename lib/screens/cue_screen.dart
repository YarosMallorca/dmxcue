import 'dart:async';

import 'package:dmxcue/components/big_stopwatch.dart';
import 'package:dmxcue/components/current_cue.dart';
import 'package:dmxcue/components/next_cue_display.dart';
import 'package:dmxcue/components/playback_controls.dart';
import 'package:dmxcue/components/playerhead.dart';
import 'package:dmxcue/components/song_flags.dart';
import 'package:dmxcue/components/top_bar.dart';
import 'package:dmxcue/providers/cue.provider.dart';
import 'package:dmxcue/providers/playback.provider.dart';
import 'package:dmxcue/providers/show.provider.dart';
import 'package:dmxcue/providers/songs.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CueScreen extends HookConsumerWidget {
  const CueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAsync = ref.watch(showProvider);

    return showAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Failed to load show\n$e',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      data: (_) => const _CueScreenContent(),
    );
  }
}

class _CueScreenContent extends HookConsumerWidget {
  const _CueScreenContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only watch the current song here — static parts depend on it
    final song = ref.watch(currentSongProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TopBar(song: song),
              const SizedBox(height: 48),
              const _TimeDisplaySection(),
              const SizedBox(height: 8),
              const Expanded(child: _CurrentCueSection()),
              const SizedBox(height: 12),
              const _NextCueSection(),
              const SizedBox(height: 16),
              SongFlags(flags: song.flags),
              const SizedBox(height: 32),
              const PlaybackControls(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeDisplaySection extends HookConsumerWidget {
  const _TimeDisplaySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      final timer = Timer.periodic(
        const Duration(milliseconds: 100),
        (_) => ref.read(playbackProvider.notifier).tick(),
      );
      return timer.cancel;
    }, []);

    final playback = ref.watch(playbackProvider);
    final song = ref.watch(currentSongProvider);

    return Column(
      children: [
        StopwatchDisplay(ms: playback.elapsedMs),
        Playerhead(elapsedMs: playback.elapsedMs, totalMs: song.durationMs),
      ],
    );
  }
}

class _CurrentCueSection extends HookConsumerWidget {
  const _CurrentCueSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCue = ref.watch(currentCueProvider);

    return CurrentCueDisplay(cue: currentCue);
  }
}

class _NextCueSection extends HookConsumerWidget {
  const _NextCueSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextCue = ref.watch(nextCueProvider);
    final currentCue = ref.watch(currentCueProvider);
    final elapsedMs = ref.watch(playbackProvider).elapsedMs;

    return NextCueDisplay(
      cue: nextCue,
      currentCue: currentCue,
      currentMs: elapsedMs,
    );
  }
}
