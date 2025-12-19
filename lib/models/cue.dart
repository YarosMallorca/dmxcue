class Cue {
  final int timeMs;
  final String label;
  final String? color;
  final String? comment;

  Cue({required this.timeMs, required this.label, this.color, this.comment});

  factory Cue.fromJson(Map<String, dynamic> json) {
    return Cue(
      timeMs: json['timeMs'] as int,
      label: json['label'] as String,
      color: json['color'] as String?,
      comment: json['comment'] as String?,
    );
  }
}
