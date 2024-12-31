import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/splash/notifier/splash_notifier.dart';

final splashProvider =
    NotifierProvider<SplashNotifier, AsyncValue<void>>(() => SplashNotifier());
