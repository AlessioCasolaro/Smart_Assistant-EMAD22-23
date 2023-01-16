import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chat_package/chat_package.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/models/media/chat_media.dart';
import 'package:chat_package/models/media/media_type.dart';
import 'package:flutter/material.dart';

import '../back/bot_service.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:sound_stream/sound_stream.dart';
import 'package:web_socket_channel/io.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:porcupine_flutter/porcupine.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:porcupine_flutter/porcupine_error.dart';

class ChatBot extends StatefulWidget {
  ChatBot({Key? key}) : super(key: key);

  @override
  _ChatBotState createState() => _ChatBotState();
}

Future loaddot() async {
  await dotenv.load(fileName: ".env");
}

final BotService _botService = BotService();

class _ChatBotState extends State<ChatBot> with WidgetsBindingObserver {
  final String accessKey = dotenv.env['PICOKEY']!;
  final String STTKey = dotenv.env['DEEPGRAMKEY']!;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, BuiltInKeyword> _keywordMap = {};

  bool isErrorPorcupine = false;
  String errorMessagePorcupine = "";

  bool isButtonDisabledPorcupine = false;
  bool isProcessingPorcupine = false;
  Color detectionColour = Color(0xff00e5c3);
  Color defaultColour = Color(0xfff5fcff);
  Color? backgroundColour;
  String currentKeyword = "Click to choose a keyword";
  PorcupineManager? _porcupineManager;

  String transcriptText = ""; //per cheetah
  final ScrollController _controller = ScrollController();

  final String serverUrl =
      'wss://api.deepgram.com/v1/listen?encoding=linear16&sample_rate=16000&language=en-US';

  final RecorderStream _recorder = RecorderStream();
  late StreamSubscription _recorderStatus;
  late StreamSubscription _audioStream;
  late IOWebSocketChannel channel;
  IconData isRecording = Icons.mic_off;
  String isRecordingText = "Not Recording";

  late ChatMessage voiceMessage;

  @override
  void initState() {
    super.initState();
    setState(() {
      isButtonDisabledPorcupine = true;
      backgroundColour = defaultColour;
      transcriptText = "";
    });
    WidgetsBinding.instance?.addPostFrameCallback(onLayoutDone);
    WidgetsBinding.instance.addObserver(this);
    _initializeKeywordMap();
    loadNewKeyword("jarvis");

    _toggleProcessingPorcupine();

    Future.delayed(const Duration(seconds: 5), () async {
      _startProcessingPorcupine();
    });
  }

  void onLayoutDone(Duration timeStamp) async {
    await Permission.microphone.request();
    setState(() {});
  }

  @override
  void dispose() {
    _recorderStatus.cancel();
    _audioStream.cancel();
    channel.sink.close();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      await _stopProcessingPorcupine();
      await _porcupineManager?.delete();
      _porcupineManager = null;
    }
  }

  Future<void> loadNewKeyword(String keyword) async {
    setState(() {
      isButtonDisabledPorcupine = true;
    });

    if (!_keywordMap.containsKey(keyword)) {
      return;
    }

    BuiltInKeyword builtIn = _keywordMap[keyword]!;

    if (isProcessingPorcupine) {
      await _stopProcessingPorcupine();
    }

    if (_porcupineManager != null) {
      await _porcupineManager?.delete();
      _porcupineManager = null;
    }
    try {
      _porcupineManager = await PorcupineManager.fromBuiltInKeywords(
          accessKey, [builtIn], wakeWordCallback,
          errorCallback: errorCallback);
      setState(() {
        currentKeyword = keyword;
        isErrorPorcupine = false;
      });
    } on PorcupineInvalidArgumentException catch (ex) {
      errorCallback(PorcupineInvalidArgumentException(
          "${ex.message}\nEnsure your accessKey '$accessKey' is a valid access key."));
    } on PorcupineActivationException {
      errorCallback(
          PorcupineActivationException("AccessKey activation error."));
    } on PorcupineActivationLimitException {
      errorCallback(PorcupineActivationLimitException(
          "AccessKey reached its device limit."));
    } on PorcupineActivationRefusedException {
      errorCallback(PorcupineActivationRefusedException("AccessKey refused."));
    } on PorcupineActivationThrottledException {
      errorCallback(PorcupineActivationThrottledException(
          "AccessKey has been throttled."));
    } on PorcupineException catch (ex) {
      errorCallback(ex);
    } finally {
      setState(() {
        isButtonDisabledPorcupine = false;
      });
    }
  }

  void wakeWordCallback(int keywordIndex) async {
    if (keywordIndex >= 0) {
      setState(() {
        backgroundColour = detectionColour;
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          backgroundColour = defaultColour;
        });
      });

      await _porcupineManager?.stop();
      log("Jarvis detected, starting listening");

      _startRecord();

      Future.delayed(const Duration(seconds: 10), () async {
        _stopRecord();
      }).whenComplete(() {
        voiceMessage = ChatMessage(
          text: transcriptText,
          isSender: true,
        );
        setState(() {
          messages.add(voiceMessage);
          _addMessage(voiceMessage);
        });
      });

      await _porcupineManager?.start();
    }
  }

  void errorCallback(PorcupineException error) {
    setState(() {
      isErrorPorcupine = true;
      errorMessagePorcupine = error.message!;
    });
  }

  Future<void> _startProcessingPorcupine() async {
    setState(() {
      isButtonDisabledPorcupine = true;
    });

    if (_porcupineManager == null) {
      await loadNewKeyword(currentKeyword);
    }

    try {
      await _porcupineManager?.start();
      setState(() {
        isProcessingPorcupine = true;
      });
    } on PorcupineException catch (ex) {
      errorCallback(ex);
    } finally {
      setState(() {
        isButtonDisabledPorcupine = false;
      });
    }
  }

  Future<void> _stopProcessingPorcupine() async {
    setState(() {
      isButtonDisabledPorcupine = true;
    });

    await _porcupineManager?.stop();

    setState(() {
      isButtonDisabledPorcupine = false;
      isProcessingPorcupine = false;
    });
  }

  void _toggleProcessingPorcupine() async {
    if (isProcessingPorcupine) {
      await _stopProcessingPorcupine();
    } else {
      await _startProcessingPorcupine();
    }
  }

  void _initializeKeywordMap() {
    for (var builtIn in BuiltInKeyword.values) {
      String keyword =
          builtIn.toString().split(".").last.replaceAll("_", " ").toLowerCase();
      _keywordMap[keyword] = builtIn;
    }
  }

  ////////////////////////////////////////////////////////////////

  Future<void> _initStream() async {
    channel = IOWebSocketChannel.connect(Uri.parse(serverUrl),
        headers: {'Authorization': 'Token $STTKey'});

    channel.stream.listen((event) async {
      final parsedJson = jsonDecode(event);

      updateText(parsedJson['channel']['alternatives'][0]['transcript']);
    });

    _audioStream = _recorder.audioStream.listen((data) {
      channel.sink.add(data);
    });

    _recorderStatus = _recorder.status.listen((status) {
      if (mounted) {
        setState(() {});
      }
    });

    await Future.wait([
      _recorder.initialize(),
    ]);
  }

  void _startRecord() async {
    transcriptText = "";
    _initStream();

    await _recorder.start();

    setState(() {
      isRecording = Icons.mic;
      isRecordingText = "Recording...";
    });
  }

  void _stopRecord() async {
    await _recorder.stop();
    await _audioStream?.cancel();
    setState(() {
      isRecording = Icons.mic_off;
      isRecordingText = "Stopped recording";
    });
  }

  void updateText(newText) {
    setState(() {
      transcriptText = transcriptText + ' ' + newText;
    });
  }

  void resetText() {
    setState(() {
      transcriptText = '';
    });
  }

  //////////////////////CHATBOT////////////////////////
  void _addMessage(ChatMessage message) async {
    ChatMessage result;
    String messageText;

    var data = await _botService.callBot(
      jsonEncode({'text': message.text}),
    );
    log(data.toString());
    //Cicla e aggiunge i messaggi
    for (var i = 0; i < data["messages"].length; i++) {
      messageText = data["messages"][i]["content"].toString();

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
          text: utf8.decode(messageText.runes.toList()),
        );
      }

      setState(() {
        messages.add(result);
      });
    }
  }

  List<ChatMessage> messages = [
    /*ChatMessage(
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
    ChatMessage(
      isSender: false,
      text: "Document:\t" + "test",
      chatMedia: ChatMedia(
        url: 'https://documenti-mskine.s3.amazonaws.com/001.pdf',
        mediaType: MediaType.audioMediaType(),
      ),
    ),*/
    ChatMessage(
        isSender: false,
        text:
            'Hello! I am Jarvis, your personal assistant. How can I help you?'),
  ];
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _stopRecord();
        _toggleProcessingPorcupine();
        Navigator.pop(context, false);

        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
            actions: [
              Text(isRecordingText),
              const SizedBox(width: 10),
              Icon(isRecording)
            ],
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _stopRecord();
                  _toggleProcessingPorcupine();
                  Navigator.pop(context, true);
                })),
        body: ChatScreen(
          chatInputFieldDecoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(100),
          ),
          attachmentClick: null,
          senderColor: Colors.blue,
          chatInputFieldColor: Color.fromARGB(255, 182, 219, 236),
          messages: messages,
          onTextSubmit: (textMessage) {
            setState(() {
              messages.add(textMessage);
              _addMessage(textMessage);
            });
          },
        ),
      ),
    );
  }
}
