import 'package:dmxcue/models/show.dart';
import 'package:dmxcue/utils/show_helpers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final showProvider = FutureProvider<Show>((ref) async {
  return loadShowFromAssets();
});
