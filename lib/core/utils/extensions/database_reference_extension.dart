import 'package:firebase_database/firebase_database.dart';
import 'package:whats_clone/core/utils/logger.dart';

extension DatabaseReferenceExtension on DatabaseReference {
  Stream<T> getStreamFromDatabase<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
     T? defaultValue,
    String? orderPath,
    int? limit,
    bool isChangeAdded = false,
  }) {
    Query query = child(path);
    if (orderPath != null) {
      query = query.orderByChild(
        orderPath,
      );
    }
    if (limit != null) {
      query = query.limitToLast(limit);
    }
    final dataStream = isChangeAdded ?query.onChildAdded :query.onValue;

    return dataStream.map(
      (event) {
        var value = event.snapshot.value;
        if (value is Map) {
          final data = value.cast<String, dynamic>();
          return fromJson(data);
        }
        if (value != null) log.w('Invalid data type ${value.runtimeType}');
        if (defaultValue != null) {
          return defaultValue;
        }
        throw Exception('Invalid data type ${value.runtimeType}');
      },
    );
  }
}
