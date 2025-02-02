import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_presence.freezed.dart';
part 'user_presence.g.dart';

@freezed
class UserPresence with _$UserPresence {
  const factory UserPresence({
    // @JsonKey(name: 'uid') required String userId,
    bool? isOnline,
    @JsonKey(fromJson: UserPresence._fromJson) DateTime? lastSeen,
  }) = _UserPresence;

  static DateTime? _fromJson(dynamic timestamp) {
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  factory UserPresence.fromJson(Map<String, dynamic> json) =>
      _$UserPresenceFromJson(json);
}
