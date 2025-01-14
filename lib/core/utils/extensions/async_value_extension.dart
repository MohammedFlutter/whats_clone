import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueExtension<T> on AsyncValue<T> {
  Future<T> asyncValueToFuture() {
    return when(
      data: (value) async => value,
      loading: () =>Future.error(Exception('Loading: Value not yet available')),
      error: (err, stack) => Future.error(err, stack),
    );
  }
}
