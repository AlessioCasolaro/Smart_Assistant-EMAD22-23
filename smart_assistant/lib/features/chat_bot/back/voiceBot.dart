import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

import 'package:sound_stream/sound_stream.dart';
import 'package:web_socket_channel/io.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:porcupine_flutter/porcupine.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:porcupine_flutter/porcupine_error.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoiceBot extends StatefulWidget {
  @override
  _VoiceBotState createState() => _VoiceBotState();
}

Future loaddot() async {
  await dotenv.load(fileName: ".env");
}

class _VoiceBotState extends State<VoiceBot> with WidgetsBindingObserver {
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
      log("Jarvis detected, starting Cheetah");

      _startRecord();

      Future.delayed(const Duration(seconds: 10), () async {
        _stopRecord();
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

    setState(() {});
  }

  void _stopRecord() async {
    await _recorder.stop();
    await _audioStream?.cancel();
    setState(() {});
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

  Color picoBlue = Color.fromRGBO(55, 125, 255, 1);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: backgroundColour,
        appBar: AppBar(
          title: const Text('Porcupine Demo'),
          backgroundColor: picoBlue,
        ),
        body: Column(
          children: [
            buildCheetahTextArea(context),
            buildStartButton(context),
            buildErrorMessage(context)
          ],
        ),
      ),
    );
  }

  buildStartButton(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        primary: picoBlue,
        shape: CircleBorder(),
        textStyle: TextStyle(color: Colors.white));

    return Expanded(
      flex: 2,
      child: Container(
          child: SizedBox(
              width: 150,
              height: 150,
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: (isButtonDisabledPorcupine || isErrorPorcupine)
                    ? null
                    : _toggleProcessingPorcupine,
                child: Text(isProcessingPorcupine ? "Stop" : "Start",
                    style: TextStyle(fontSize: 30)),
              ))),
    );
  }

  buildErrorMessage(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20, right: 20),
            decoration: !isErrorPorcupine
                ? null
                : BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(5)),
            child: !isErrorPorcupine
                ? null
                : Text(
                    errorMessagePorcupine,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )));
  }

  buildCheetahTextArea(BuildContext context) {
    return Expanded(
        flex: 6,
        child: Container(
            alignment: Alignment.topCenter,
            color: Color(0xff25187e),
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
                controller: _controller,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(10),
                physics: RangeMaintainingScrollPhysics(),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      transcriptText,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )))));
  }
}
