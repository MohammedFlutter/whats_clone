import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

final timeAgoProvider = Provider.autoDispose
    .family<String, (DateTime dateTime, AppLocalizations l10n)>((ref, args) {
  final dateTime = args.$1;
  final l10n = args.$2;

  final duration = ref.watch(currentTimeProvider).difference(dateTime);

  if (duration.inDays >= 365) {
    final years = (duration.inDays / 365).floor();
    return l10n.yearsAgo(years);
  } else if (duration.inDays >= 30) {
    final months = (duration.inDays / 30).floor();
    return l10n.monthsAgo(months);
  } else if (duration.inDays >= 7) {
    final weeks = (duration.inDays / 7).floor();
    return l10n.weeksAgo(weeks);
  } else if (duration.inDays >= 1) {
    return l10n.daysAgo(duration.inDays);
  } else if (duration.inHours >= 1) {
    return l10n.hoursAgo(duration.inHours);
  } else if (duration.inMinutes >= 1) {
    return l10n.minutesAgo(duration.inMinutes);
  } else {
    return l10n.justNow;
  }
});
