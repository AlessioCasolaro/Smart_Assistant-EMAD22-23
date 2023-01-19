import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_assistant/shared/res/colors.dart';

const appId = "54fd071157824221b82bac9459192a35";
const token =
    "007eJxTYPjhzftfXH2vnvWjJ8WCn3T1glX2fosJPfS8L9R0sbn7hf8KDKYmaSkG5oaGpuYWRiZGRoZJFkZJicmWJqaWhpZGicammT7TkxsCGRkcLBwYGKEQxGdlCCjKL0tkYAAAKYEeAA==";
const channel = "Prova";

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({Key? key}) : super(key: key);

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  bool isCameraOn = true;
  bool isMicOn = true;
  bool isFrontCamera = true;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera, Permission.storage, Permission.mediaLibrary].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      options: const ChannelMediaOptions(),
      uid: 0,
    );
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              height: 350,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
          //row of video calls buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RawMaterialButton(
                    onPressed: () async {
                      if(isCameraOn){
                        await _engine.disableVideo();
                        setState(() {
                          isCameraOn = false;
                        });
                      }
                      else{
                        await _engine.enableVideo();
                        setState(() {
                          isCameraOn = true;
                        });
                      }
                    },
                    child: isCameraOn ? 
                    const Icon(
                      Icons.videocam,
                      color: Colors.white,
                      size: 35.0,
                    ) :
                    const Icon(
                      Icons.videocam_off,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    shape: const CircleBorder(),
                    elevation: 2.0,
                    fillColor: SmartAssistantColors.primary,
                    padding: const EdgeInsets.all(15.0),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      if(isMicOn){
                        await _engine.muteLocalAudioStream(true);
                        setState(() {
                          isMicOn = false;
                        });
                      }
                      else{
                        await _engine.muteLocalAudioStream(false);
                        setState(() {
                          isMicOn = true;
                        });
                      }
                    },
                    child: 
                    isMicOn ? 
                    const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 35.0,
                    ) :
                    const Icon(
                      Icons.mic_off,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    shape: const CircleBorder(),
                    elevation: 2.0,
                    fillColor: SmartAssistantColors.primary,
                    padding: const EdgeInsets.all(15.0),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      await _engine.leaveChannel();
                      await _engine.release();
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    shape: const CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.redAccent,
                    padding: const EdgeInsets.all(15.0),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      await _engine.switchCamera();
                      setState(() {
                        isFrontCamera = !isFrontCamera;
                      });
                    }, 
                    child: isFrontCamera ? 
                    const Icon(
                      Icons.camera_rear,
                      color: Colors.white,
                      size: 35.0,
                    ) :
                    const Icon(
                      Icons.camera_front,
                      color: Colors.white,
                      size: 35.0,
                    ) ,
                    shape: const CircleBorder(),
                    elevation: 2.0,
                    fillColor: SmartAssistantColors.primary,
                    padding: const EdgeInsets.all(15.0),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      DateTime today = DateTime.now();
                      String dateStr = "${today.hour}${today.minute}${today.second}-${today.day}-${today.month}-${today.year}";
                      await _engine.takeSnapshot(uid: 0, filePath: '/storage/emulated/0/Android/data/com.example.smart_assistant/files/Screenshot-$dateStr.jpg'); //Screenshot-184500-20-10-2020.jpg
                    }, 
                    child: const Icon(
                      Icons.screenshot,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    shape: const CircleBorder(),
                    elevation: 2.0,
                    fillColor: SmartAssistantColors.primary,
                    padding: const EdgeInsets.all(15.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
