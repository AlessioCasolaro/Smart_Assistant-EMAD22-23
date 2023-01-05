import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  VideoScreenState();
  String url = 'https://youtu.be/V89BOZhJFlI';

  late YoutubePlayerController _controller;

  Widget build(BuildContext context) {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
      ),
    );

    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          liveUIColor: Colors.amber,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          progressColors: const ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
        ),
        builder: (context, player) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Youtube Player Flutter',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: Column(children: [
                player,
              ]),
            ));
  }
}
