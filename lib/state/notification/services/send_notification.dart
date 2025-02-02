import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:whats_clone/core/secrets.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/notification/services/fcm_token_repository.dart';

class SendNotification {
  SendNotification({required FcmTokenRepository fcmTokenRepository})
      : _fcmTokenRepository = fcmTokenRepository;
  final FcmTokenRepository _fcmTokenRepository;

  static String? _serverToken;

  Future<void> sendNotification({
    required String title,
    required String recipientId,
    String description = '',
    Map<String, dynamic> data = const {},
  }) async {
    try {
      final recipientToken =
          await _fcmTokenRepository.getTokenByUserId(recipientId);
      if (recipientToken == null || recipientToken.token == null) {
        log.e('Recipient token is null for userId: $recipientId');
        return;
      }

      final serverToken = await _getServerToken();
      final response = await _sendNotificationRequest(
        title: title,
        description: description,
        recipientToken: recipientToken.token!,
        data: data,
        serverToken: serverToken,
      );

      _handleResponse(response, recipientId);
    } catch (e, s) {
      log.e('Error sending notification', error: e, stackTrace: s);
    }
  }

  /// Sends the notification request to FCM
  Future<http.Response> _sendNotificationRequest({
    required String title,
    required String description,
    required String recipientToken,
    required Map<String, dynamic> data,
    required String serverToken,
  }) async {
    final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/whats-clone-62037/messages:send');
    final notification = {
      "title": title,
      "body": description,
    };
    final body = {
      "message": {
        "token": recipientToken,
        "data": data,
        "notification": notification,
      }
    };

    final headers = {
      'Authorization': 'Bearer $serverToken',
      'Content-Type': 'application/json',
    };

    return await http.post(
      url,
      body: jsonEncode(body),
      headers: headers,
    );
  }

  /// Handles the FCM response, including error cases
  void _handleResponse(http.Response response, String recipientId) async {
    if (response.statusCode == 200) {
      log.i('Notification sent successfully');
    } else {
      log.e('Failed to send notification: ${response.body}');

      if (response.body.contains('registration-token-not-registered') ||
          response.body.contains('invalid-registration-token')) {
        log.w('Invalid or expired recipient token. Deleting token.');
        await _fcmTokenRepository.deleteToken(recipientId);
      }
    }
  }

  Future<String> _getServerToken() async {
    if (_serverToken != null) return _serverToken!;
    // final serviceAccountKey = await rootBundle.loadString('assets/your-service-account.json');
    // final credentials = ServiceAccountCredentials.fromJson(json.decode(serviceAccountKey));
    final credentials = ServiceAccountCredentials.fromJson(firebaseAdmin);

    final scopes = ['https://www.googleapis.com/auth/cloud-platform'];

    // Get an authenticated HTTP client
    final client = await clientViaServiceAccount(credentials, scopes);

    _serverToken = client.credentials.accessToken.data;
    return _serverToken!;
  }
}
