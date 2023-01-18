import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_assistant/features/dashboard/classes/Response.dart';
import 'package:smart_assistant/features/dashboard/widgets/machine_statsRow.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            _buildYtbView(),
            _buildTitle(),
            _buildMachineStatsView(),
          ],
        ),
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

  _buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Machine Stats',
            style: TextStyles.body.copyWith(
              fontSize: TextStyles.headline2.fontSize,
              color: SmartAssistantColors.primary,
            ),
          )
        ],
      ),
    );
  }

  _buildMachineStatsView() {
    return Expanded(
      child: Container(
        child: MachineStats(
          macchina: machine!,
          box: BoxDecoration(color: Colors.white),
        ),
      ),
    );
  }
}
