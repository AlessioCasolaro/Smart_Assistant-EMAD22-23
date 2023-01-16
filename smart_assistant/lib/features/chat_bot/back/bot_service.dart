import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:sigv4/sigv4.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BotService {
  late Map<String, dynamic> result;
  String bots = dotenv.env['BOTS'].toString()!;
  String kAccessKeyId = dotenv.env['ACCESS_KEY']!;
  String kSecretAccessKey = dotenv.env['SECRET_KEY']!;
  String botAlias = dotenv.env['BOT_ALIAS'].toString()!;
  String botAWSRegion = dotenv.env['REGION']!;
  var rng = Random();

  Future<Map<String, dynamic>> callBot(String message) async {
    //https://runtime-v2-lex.us-east-1.amazonaws.com/bots/botId/botAliases/botAliasId/botLocales/localeId/sessions/sessionId/text
    http.Response response;
    String requestUrl = "https://runtime-v2-lex.us-east-1.amazonaws.com/bots/" +
        bots +
        "/botAliases/" +
        botAlias +
        "/botLocales/en_US/sessions/" +
        (1000 + rng.nextInt(1000)).toString() +
        "/text";

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
      body: jsonEncode({
        "requestAttributes": {"codiceProcesso": "3", "codiceTopic": "1"},
        'text': message
      }),
    );
    //debugPrint("REQUEST" + request.body);

    response = await http.post(request.url,
        headers: request.headers, body: request.body);
    result = jsonDecode(response.body);
    //print("Request" + request.toString());
    return result;
  }
}
