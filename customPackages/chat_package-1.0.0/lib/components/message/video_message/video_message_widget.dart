import 'dart:io';
import 'package:chat_package/utils/transparent_image.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:chat_package/components/message/video_message/videoPlayer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//TODO add text size
class VideoMessageWidget extends StatelessWidget {
  /// chat message model to get teh data
  final ChatMessage message;

  ///the color of the sender container
  final Color senderColor;

  final TextStyle? messageContainerTextStyle;

  const VideoMessageWidget({
    Key? key,
    required this.message,
    required this.senderColor,
    this.messageContainerTextStyle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String videoId = message.chatMedia!.url
        .substring(message.chatMedia!.url.length - 11); //For preview image

    String getThumbnail({
      required String videoId,
      String quality = ThumbnailQuality.standard,
      bool webp = true,
    }) =>
        webp
            ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
            : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';

    return Column(
      crossAxisAlignment:
          message.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: senderColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: message.isSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  /// navigate to to the photo gallery view, for viewing the taped image
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => YoutubeVideoPlayer(
                            titleGet: message.text!.toString(),
                            urlGet: message.chatMedia!.url.toString())),
                  );
                },
                child: Container(
                  /// 45% of total width
                  width: MediaQuery.of(context).size.width * 0.45,

                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: FadeInImage.memoryNetwork(
                        placeholder: transparentImage,
                        image: getThumbnail(videoId: videoId ?? ""),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: message.text.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 8,
                    top: 8,
                    right: message.isSender ? 8 : 0,
                    left: message.isSender ? 0 : 8,
                  ),
                  child: Text(
                    message.text,
                    style:
                        messageContainerTextStyle ?? TextStyle(fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
