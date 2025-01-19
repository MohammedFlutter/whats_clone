import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentTimeNotifier extends StateNotifier<DateTime> {
  late final Timer _timer;

  CurrentTimeNotifier() : super(DateTime.now()) {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      state = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

final currentTimeProvider =
    StateNotifierProvider<CurrentTimeNotifier, DateTime>(
  (ref) => CurrentTimeNotifier(),
);

final timeAgoProvider =
    Provider.autoDispose.family<String, DateTime>((ref, dateTime) {
  final duration = ref.watch(currentTimeProvider).difference(dateTime);
  if (duration.inDays > 0) {
    return '${duration.inDays}d ago';
  } else if (duration.inHours > 0) {
    return '${duration.inHours}h ago';
  } else if (duration.inMinutes > 0) {
    return '${duration.inMinutes}m ago';
  } else {
    return 'Just now';
  }
});
