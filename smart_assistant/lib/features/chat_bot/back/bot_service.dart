import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sigv4/sigv4.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BotService {
  late Map<String, dynamic> result;
  String botName = '';
  String kAccessKeyId = '';
  String kSecretAccessKey = '';
  String botAlias = '';
  String botAWSRegion = '';

  Future<Map<String, dynamic>> callBot(String message) async {
    var response;
    String requestUrl = "https://runtime.lex." +
        botAWSRegion +
        ".amazonaws.com/bot/" +
        botName +
        "/alias/" +
        botAlias +
        "/user/12345/text";

    Sigv4Client client = Sigv4Client(
      region: botAWSRegion,
      serviceName: 'lex',
      defaultContentType: 'application/json; charset=utf-8',
      keyId: kAccessKeyId,
      accessKey: kSecretAccessKey,
    );

    final request = client.request(
      requestUrl,
      method: 'POST',
      body: jsonEncode({'inputText': message}),
    );

    response = await http.post(request.url,
        headers: request.headers, body: request.body);
    result = jsonDecode(response.body);
    return result;
  }
}
