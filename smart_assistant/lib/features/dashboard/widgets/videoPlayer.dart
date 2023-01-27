import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_assistant/features/dashboard/classes/Response.dart';
import 'package:smart_assistant/features/dashboard/widgets/machine_stats.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../shared/res/res.dart';

String title = '';
String url = '';
OggettoOggetto? machine;

class YoutubeVideoPlayer extends StatefulWidget {
  YoutubeVideoPlayer(
      {Key? key,
      required titleGet,
      required urlGet,
      required OggettoOggetto oggetto})
      : super(key: key) {
    title = titleGet;
    url = urlGet;
    machine = oggetto;
  }

  @override
  _YoutubeVideoPlayerState createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  late YoutubePlayerController _ytbPlayerController;
  @override
  void initState() {
    super.initState();

    _setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    log(url);
    log(url.substring(url.length - 11));
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _ytbPlayerController = YoutubePlayerController(
          initialVideoId: url.substring(url.length - 11),
          params: YoutubePlayerParams(
            showFullscreenButton: true,
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _ytbPlayerController.close();
  }

  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: SmartAssistantColors.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          MachineStats(
              macchina: machine!,
              box: const BoxDecoration(color: Color(0xFF1F75FE))),
          SizedBox(height: 120.h),
          _buildYtbView(),
        ],
      ),
    );
  }

  _buildYtbView() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _ytbPlayerController != null
          ? YoutubePlayerIFrame(controller: _ytbPlayerController)
          : Center(child: CircularProgressIndicator()),
    );
  }
}
