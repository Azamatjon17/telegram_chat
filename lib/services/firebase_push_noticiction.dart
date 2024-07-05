import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class FirebasePushNoticiction {
  static final _pushNotification = FirebaseMessaging.instance;
  static final notificationPermition = _pushNotification.requestPermission();
  static final token = _pushNotification.getToken();

  static Future<bool> sendMessagetoUser({
    required String token,
    required String userName,
    required String text,
  }) async {
    await Future.delayed(Duration(seconds: 5));
    final jsonAcountData = await rootBundle.loadString('service-account.json');
    final acountCredentials = ServiceAccountCredentials.fromJson(jsonAcountData);
    final scopes = ['https://www.googleapis.com/auth/cloud-platform'];
    final client = await clientViaServiceAccount(acountCredentials, scopes);



    final notificationData = {
      'message': {
        'token': token,
        'notification': {
          'title': userName,
          'body': text,
        }
      },
    };

    const projectId = 'telegram-chat-299af';
    final url = Uri.parse("https://fcm.googleapis.com/v1/projects/$projectId/messages:send");
    final response = await client.post(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer ${client.credentials.accessToken}',
      },
      body: jsonEncode(notificationData),
    );
    client.close();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
