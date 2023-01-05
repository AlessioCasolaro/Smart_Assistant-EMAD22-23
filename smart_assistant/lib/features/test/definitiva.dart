import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:porcupine_flutter/porcupine.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:porcupine_flutter/porcupine_error.dart';

import 'cheetah_manager.dart';
import 'package:cheetah_flutter/cheetah_error.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class PorcupineWake extends StatefulWidget {
  @override
  _PorcupineWakeState createState() => _PorcupineWakeState();
}

Future loaddot() async {
  await dotenv.load(fileName: ".env");
}

class _PorcupineWakeState extends State<PorcupineWake>
    with WidgetsBindingObserver {
  final String accessKey = dotenv.env['PICOKEY']!;

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
  CheetahManager? _cheetahManager;
  final ScrollController _controller = ScrollController();
  bool isProcessingCheetah = false;
  bool isErrorCheetah = false;
  String errorMessageCheetah = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      isButtonDisabledPorcupine = true;
      backgroundColour = defaultColour;
      transcriptText = "";
    });
    WidgetsBinding.instance.addObserver(this);
    _initializeKeywordMap();
    loadNewKeyword("jarvis");
    initCheetah();
  }

  @override
  void dispose() {
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

  void wakeWordCallback(int keywordIndex) {
    if (keywordIndex >= 0) {
      setState(() {
        backgroundColour = detectionColour;
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          backgroundColour = defaultColour;
        });
      });
      _startProcessingCheetah();
      log("Jarvis detected, starting Cheetah");

      Future.delayed(const Duration(seconds: 10), () {
        log("Stopping Cheetah");
        _stopProcessingCheetah();
      });
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

//FINE PROCUPINE/////////////////////////////////////////////

  Future<void> initCheetah() async {
    String platform = Platform.isAndroid
        ? "android"
        : Platform.isIOS
            ? "ios"
            : throw CheetahRuntimeException(
                "This demo supports iOS and Android only.");
    String modelPath = "assets/models/$platform/cheetah_params.pv";

    try {
      _cheetahManager = await CheetahManager.create(
          accessKey, modelPath, transcriptCallback, errorCallbackCheetah);
    } on CheetahInvalidArgumentException catch (ex) {
      errorCallbackCheetah(CheetahInvalidArgumentException(
          "${ex.message}\nEnsure your accessKey '$accessKey' is a valid access key."));
    } on CheetahActivationException {
      errorCallbackCheetah(
          CheetahActivationException("AccessKey activation error."));
    } on CheetahActivationLimitException {
      errorCallbackCheetah(CheetahActivationLimitException(
          "AccessKey reached its device limit."));
    } on CheetahActivationRefusedException {
      errorCallbackCheetah(
          CheetahActivationRefusedException("AccessKey refused."));
    } on CheetahActivationThrottledException {
      errorCallbackCheetah(
          CheetahActivationThrottledException("AccessKey has been throttled."));
    } on CheetahException catch (ex) {
      errorCallbackCheetah(ex);
    }
  }

  void transcriptCallback(String transcript) {
    bool shouldScroll =
        _controller.position.pixels == _controller.position.maxScrollExtent;

    setState(() {
      transcriptText = transcriptText + transcript;
    });
    log("TESTO: " + transcriptText);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (shouldScroll && !_controller.position.atEdge) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  void errorCallbackCheetah(CheetahException error) {
    setState(() {
      isErrorCheetah = true;
      errorMessageCheetah = error.message!;
    });
  }

  Future<void> _startProcessingCheetah() async {
    if (isProcessingCheetah) {
      return;
    }

    try {
      await _cheetahManager!.startProcess();
      setState(() {
        transcriptText = "";
        isProcessingCheetah = true;
      });
    } on CheetahException catch (ex) {
      print("Failed to start audio capture: ${ex.message}");
    }
  }

  Future<void> _stopProcessingCheetah() async {
    if (!isProcessingCheetah) {
      return;
    }

    try {
      await _cheetahManager!.stopProcess();
      setState(() {
        isProcessingCheetah = false;
      });
    } on CheetahException catch (ex) {
      print("Failed to start audio capture: ${ex.message}");
    }
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
