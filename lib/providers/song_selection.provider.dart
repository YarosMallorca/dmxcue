import 'package:hooks_riverpod/hooks_riverpod.dart';

class SongSelectionState {
  final int index;

  const SongSelectionState(this.index);
}

final songSelectionProvider =
    NotifierProvider<SongSelectionNotifier, SongSelectionState>(
      SongSelectionNotifier.new,
    );

class SongSelectionNotifier extends Notifier<SongSelectionState> {
  @override
  SongSelectionState build() {
    return const SongSelectionState(0);
  }

  void select(int index) {
    state = SongSelectionState(index);
  }

  void next(int max) {
    if (state.index < max - 1) {
      state = SongSelectionState(state.index + 1);
    }
  }

  void previous() {
    if (state.index > 0) {
      state = SongSelectionState(state.index - 1);
    }
  }
}
