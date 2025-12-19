import 'package:dmxcue/models/song.dart';

class Show {
  final int version;
  final String show;
  final List<Song> songs;

  Show({required this.version, required this.show, required this.songs});

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      version: json['version'] as int,
      show: json['show'] as String,
      songs: (json['songs'] as List<dynamic>)
          .map((e) => Song.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
