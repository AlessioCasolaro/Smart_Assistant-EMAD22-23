import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_assistant/shared/res/colors.dart';
import 'package:uuid/uuid.dart';

import '../../task_list/classes/Response.dart';
import '../back/bot_service.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  List<types.Message> messages = [];
  final _user = const types.User(id: '1234556');
  final _bot = const types.User(id: "123");
//id of bot and user doesn't matter here as we have only pair interaction

  final BotService _botService = BotService();

  Future loaddot() async {
    await dotenv.load(fileName: ".env");
  }

  @override
  void initState() {
    super.initState();
    loaddot();
    _loadMessages();
  }

  void _addMessage(types.Message message) async {
    setState(() {
      messages.insert(0, message);
    });
    var data = await _botService.callBot(message.toJson()["text"]);

    //Cicla e aggiunge i messaggi
    for (var i = 0; i < data["messages"].length; i++) {
      var message = data["messages"][i]["content"];
      //if (data["messages"][i].contains(["imageResponseCard"]))
      //var temp = data["messages"][i]["imageResponseCard"];
      //log("Print buttons ${temp["buttons"]}");
      setState(() {
        messages.insert(0, botMessageReply(message));
      });
    }
  }

  types.Message botMessageReply(String message) {
    return types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message,
    );
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _addMessage(textMessage);
  }

  void _loadMessages() async {
    List<types.Message> messagesList = [];
    Future.delayed(const Duration(milliseconds: 300), () {
      messagesList.add(types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text:
            "Hello. My name is SmartAssistantBOT your bot. How can I help you?",
      ));

      setState(() {
        messages = messagesList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text("Chat-BOT"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: 20.0,
              onPressed: () {
                _goBack(context);
              },
            ),
            backgroundColor: SmartAssistantColors.primary),
        body: Chat(
          messages: messages,
          showUserNames: true,
          onSendPressed: _handleSendPressed,
          user: _user,
          theme: const DefaultChatTheme(
            primaryColor: Color(0xFF1F75FE),
            receivedMessageBodyTextStyle: TextStyle(
              fontSize: 24,
            ),
            sentMessageBodyTextStyle: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ));
  }

  _goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
