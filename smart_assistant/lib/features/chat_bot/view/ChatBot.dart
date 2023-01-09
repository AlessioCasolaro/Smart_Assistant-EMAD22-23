import 'dart:convert';
import 'dart:developer';

import 'package:chat_package/chat_package.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/models/media/chat_media.dart';
import 'package:chat_package/models/media/media_type.dart';
import 'package:flutter/material.dart';

import '../back/bot_service.dart';

class ChatBot extends StatefulWidget {
  ChatBot({Key? key}) : super(key: key);

  @override
  _ChatBotState createState() => _ChatBotState();
}

final BotService _botService = BotService();

class _ChatBotState extends State<ChatBot> {
  void _addMessage(ChatMessage message) async {
    ChatMessage result;
    String messageText;
    setState(() {
      messages.insert(0, message);
    });
    var data = await _botService.callBot(
      jsonEncode({'text': message.text}),
    );

    //Cicla e aggiunge i messaggi
    for (var i = 0; i < data["messages"].length; i++) {
      messageText = data["messages"][i]["content"].toString();
      log(data["messages"][i]["content"]);
      if (messageText.contains("youtu")) {
        result = ChatMessage(
          isSender: false,
          text: messageText,
          chatMedia: ChatMedia(
            url: messageText,
            mediaType: MediaType.videoMediaType(),
          ),
        );
      } else {
        result = ChatMessage(
          isSender: false,
          text: messageText,
        );
      }

      setState(() {
        messages.add(result);
      });
    }
  }

  List<ChatMessage> messages = [
    ChatMessage(
      isSender: true,
      text: 'this is a banana',
      chatMedia: ChatMedia(
        url:
            'https://images.pexels.com/photos/7194915/pexels-photo-7194915.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
        mediaType: MediaType.imageMediaType(),
      ),
    ),
    ChatMessage(
      isSender: false,
      text: "test",
      chatMedia: ChatMedia(
        url: 'https://youtu.be/lzBExDLJvpE',
        mediaType: MediaType.videoMediaType(),
      ),
    ),
    ChatMessage(isSender: false, text: 'wow that is cool'),
  ];
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ChatScreen(
        messages: messages,
        onTextSubmit: (textMessage) {
          setState(() {
            messages.add(textMessage);
            _addMessage(textMessage);
          });
        },
      ),
    );
  }
}
