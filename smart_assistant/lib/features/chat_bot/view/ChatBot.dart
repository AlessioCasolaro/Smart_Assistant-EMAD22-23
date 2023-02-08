import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:chat_package/chat_package.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/models/media/chat_media.dart';
import 'package:chat_package/models/media/media_type.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_assistant/features/dashboard/widgets/widgets.dart';
import 'package:smart_assistant/features/dashboard/classes/Response.dart'
    as DashResp;

import '../../../shared/res/colors.dart';
import '../back/bot_service.dart';
import '../models/responseParser.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:sound_stream/sound_stream.dart';
import 'package:web_socket_channel/io.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:porcupine_flutter/porcupine.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:porcupine_flutter/porcupine_error.dart';

DashResp.OggettoOggetto? ogg;

class ChatBot extends StatefulWidget {
  ChatBot({required DashResp.OggettoOggetto oggetto, Key? key})
      : super(key: key) {
    ogg = oggetto;
  }

  @override
  _ChatBotState createState() => _ChatBotState();
}

Future loaddot() async {
  await dotenv.load(fileName: ".env");
}

final BotService _botService = BotService();

class _ChatBotState extends State<ChatBot> with WidgetsBindingObserver {
  //Loading the .env keys
  final String accessKey = dotenv.env['PICOKEY']!;
  final String STTKey = dotenv.env['DEEPGRAMKEY']!;

  //Porcupine
  final Map<String, BuiltInKeyword> _keywordMap = {};
  bool isErrorPorcupine = false;
  String errorMessagePorcupine = "";

  bool isButtonDisabledPorcupine = false;
  bool isProcessingPorcupine = false;

  String currentKeyword = "jarvis";
  PorcupineManager? _porcupineManager;

  //Deepgram
  final String serverUrl =
      'wss://api.deepgram.com/v1/listen?encoding=linear16&sample_rate=16000&language=en-US';

  String transcriptText = ""; // Deepgram
  final RecorderStream _recorder = RecorderStream();
  late StreamSubscription _recorderStatus;
  late StreamSubscription _audioStream;
  late IOWebSocketChannel channel;

  //Microphone
  IconData isRecording = Icons.mic_off;
  String isRecordingText = "Not Recording";
  bool isRecordingBool = false;

  late ChatMessage voiceMessage;
  bool isTopic = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isButtonDisabledPorcupine = true;
    });
    WidgetsBinding.instance?.addPostFrameCallback(onLayoutDone);
    WidgetsBinding.instance.addObserver(this);
    _initializeKeywordMap();

    Future.delayed(const Duration(seconds: 5), () async {
      _toggleProcessingPorcupine();
      isRecordingText = "Waiting for keyword";
    });
  }

  void onLayoutDone(Duration timeStamp) async {
    await Permission.microphone.request();
    setState(() {});
  }

  @override
  void dispose() {
    if (isRecordingBool) {
      _recorderStatus.cancel();
      _audioStream.cancel();
      channel.sink.close();
    }
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
      await _porcupineManager?.stop();
      log("Jarvis detected, starting listening");

      _startRecord();

      CherryToast(
              icon: Icons.mic,
              iconColor: SmartAssistantColors.primary,
              iconSize: 20.sp,
              themeColor: SmartAssistantColors.primary,
              title: Text("Jarvis is listening ...",
                  style: TextStyle(
                    color: SmartAssistantColors.primary,
                    fontSize: 18.sp,
                  )),
              toastPosition: Position.bottom,
              toastDuration: Duration(seconds: 5),
              animationType: AnimationType.fromTop,
              autoDismiss: true)
          .show(context);

      Future.delayed(const Duration(seconds: 5), () async {
        _stopRecord();
      }).whenComplete(() {
        voiceMessage = ChatMessage(
          text: transcriptText,
          isSender: true,
        );

        if (!mounted) return;

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

  ///////////////////////////Deepgram/////////////////////////////////////

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
      isRecordingBool = true;
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
    Response response;
    late ChatMessage result;
    Response messageText;
    var data;
    var jsonTopic;
    bool isYoutube = false;

    if (!isTopic) {
      data = await _botService.callBot(
        jsonEncode({'text': message.text}),
        null,
      );
    } else {
      data = await _botService.callBot(
        jsonEncode({
          'text': "aiutami con l'intervento"
        }), //Per continuare col flusso di topic
        message.text,
      );
    }
    log("Log chiamata" + data.toString());
    var fixJson = jsonEncode(data);
    final resp = responseFromJson(fixJson);

    //Cicla sulla response
    for (var i = 0; i < resp!.messages!.length; i++) {
      log(resp.messages![i]!.content![i]!.codiceTopic.toString());

      if (resp.messages![i]!.content![0]!.codiceTopic != null &&
          resp.messages![i]!.content![0]!.codiceTopic != "") {
        //Se trova un topic
        String topicGenerated =
            "Choose one of the following topics and I will recommend a media:\n\n";
        for (var j = 0; j < resp.messages![i]!.content!.length; j++) {
          //Cicla sui topic
          topicGenerated = topicGenerated +
              resp.messages![i]!.content![j]!.codiceTopic.toString() +
              " " +
              resp.messages![i]!.content![j]!.nome.toString() +
              "\n";
        }
        result = ChatMessage(
          //Crea il messaggio con il topic
          isSender: false,
          text: topicGenerated,
        );
        isTopic =
            true; //Setta la variabile isTopic a true per far eseguire il passo successivo della lambda, ovvero restituire i documenti consigliati per quel topic

        setState(() {
          messages.add(result);
        });
      } else if (resp.messages![i]!.content![0]!.riferimentoDocumentale !=
              null &&
          resp.messages![i]!.content![0]!.riferimentoDocumentale != "") {
        //Altrimenti se trova un documento

        for (var j = 0; j < resp.messages![i]!.content!.length; j++) {
          if ((resp.messages![i]!.content![0]!
                  .riferimentoDocumentale) //Se è un video di youtube
              .toString()
              .contains("youtu")) {
            isYoutube = true; // Setta la variabile isYoutube a true
          }
          result = ChatMessage(
            //Aggiunge il messaggio a seconda dell'esito della isYoutube
            isSender: false,
            text: isYoutube
                ? "Video:\t" + resp.messages![i]!.content![j]!.titolo.toString()
                : "Document:\t" +
                    resp.messages![i]!.content![j]!.titolo.toString(),
            chatMedia: ChatMedia(
              url: resp.messages![i]!.content![j]!.riferimentoDocumentale
                  .toString(),
              mediaType: isYoutube
                  ? MediaType.videoMediaType() //Se è un video di youtube
                  : MediaType
                      .audioMediaType(), //Se è un documento(i documenti vengono trattati come audioMediaType)
            ),
          );
          isYoutube =
              false; //A prescindere setto la variabile isYoutube a false
          isTopic =
              false; //Ho finito di trattare il topic, setto la variabile isTopic a false
          setState(() {
            messages.add(result);
          });
        }
      } else if (resp.messages![i]!.content![0]!.stringa != null &&
          resp.messages![i]!.content![0]!.stringa != "") {
        //Se non trova ne topic ne documenti
        result = ChatMessage(
            isSender: false,
            text: utf8.decode(
                resp.messages![i]!.content![0]!.stringa!.runes.toList()));
        setState(() {
          messages.add(result);
        });
      } else {
        result = ChatMessage(
            isSender: false,
            text: utf8.decode(
                resp.messages![i]!.content![0]!.toString().runes.toList()));
        setState(() {
          messages.add(result);
        });
      }
    }
  }

  List<ChatMessage> messages = [
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
        Navigator.pop(context, false);

        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: SmartAssistantColors.primary,
            elevation: 0,
            actions: [
              Container(
                  padding: //inserisci del padding
                      EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    children: [
                      Text(isRecordingText),
                      const SizedBox(width: 20),
                      Icon(isRecording)
                    ],
                  ))
            ],
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  //_stopRecord();
                  _toggleProcessingPorcupine();
                  Navigator.pop(context, true);
                })),
        body: Column(
          children: [
            MachineStats(
                macchina: ogg!,
                box: const BoxDecoration(color: Color(0xFF1F75FE))),
            const SizedBox(height: 10),
            Expanded(
              child: ChatScreen(
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
          ],
        ),
      ),
    );
  }
}
