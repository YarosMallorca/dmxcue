import 'package:dmxcue/models/cue.dart';

class Song {
  final String id;
  final String title;
  final String? artist;
  final int durationMs;
  final List<String> flags;
  final String? notes;
  final List<Cue> cues;

  Song({
    required this.id,
    required this.title,
    this.artist,
    required this.durationMs,
    this.flags = const [],
    this.notes,
    required this.cues,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    final cues =
        (json['cues'] as List<dynamic>)
            .map((e) => Cue.fromJson(e as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.timeMs.compareTo(b.timeMs));

    return Song(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String?,
      durationMs: json['durationMs'] as int,
      flags:
          (json['flags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      notes: json['notes'] as String?,
      cues: cues,
    );
  }
}
