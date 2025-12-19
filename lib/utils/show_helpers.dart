import 'dart:convert';
import 'package:dmxcue/models/cue.dart';
import 'package:dmxcue/models/show.dart';
import 'package:dmxcue/models/song.dart';
import 'package:flutter/services.dart';

Future<Show> loadShowFromAssets() async {
  final jsonString = await rootBundle.loadString('assets/cues.json');
  final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
  return Show.fromJson(jsonMap);
}

Cue? getCurrentCue(Song song, int elapsedMs) {
  Cue? current;
  for (final cue in song.cues) {
    if (cue.timeMs <= elapsedMs) {
      current = cue;
    } else {
      break;
    }
  }
  return current;
}

Cue? getNextCue(Song song, int elapsedMs) {
  for (final cue in song.cues) {
    if (cue.timeMs > elapsedMs) {
      return cue;
    }
  }
  return null;
}

String formatTime(int ms) {
  final m = (ms ~/ 60000).toString().padLeft(2, '0');
  final s = ((ms % 60000) ~/ 1000).toString().padLeft(2, '0');
  return '$m:$s';
}
