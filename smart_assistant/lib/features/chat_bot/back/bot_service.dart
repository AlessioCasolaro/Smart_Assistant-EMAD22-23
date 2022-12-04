import 'dart:convert';

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
  String botAWSRegion = 'us-east-1';

  Future<Map<String, dynamic>> callBot(String message) async {
    //https://runtime-v2-lex.us-east-1.amazonaws.com/bots/botId/botAliases/botAliasId/botLocales/localeId/sessions/sessionId/text
    http.Response response;
    String requestUrl = "";

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
      body: jsonEncode({'text': message}),
    );
    //debugPrint("REQUEST" + request.body);

    response = await http.post(request.url,
        headers: request.headers, body: request.body);
    result = jsonDecode(response.body);
    //debugPrint("Request" + request.toString());
    return result;
  }
}
