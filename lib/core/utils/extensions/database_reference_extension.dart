import 'package:firebase_database/firebase_database.dart';
import 'package:whats_clone/core/utils/logger.dart';

extension DatabaseReferenceExtension on DatabaseReference {
  Stream<T> getStreamFromDatabase<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
    required T defaultValue,
  }) {
    return child(path).onValue.map(
      (event) {
        var value = event.snapshot.value;

        if (value is Map) {
          final data = value.cast<String, dynamic>();
          return fromJson(data);
        }
        if (value != null) log.w('Invalid data type ${value.runtimeType}');
        return defaultValue;
      },
    );
  }
}
