import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_assistant/features/chat_bot/view/ChatBot.dart';
import 'package:smart_assistant/features/search/views/Search.dart';
import 'package:smart_assistant/features/video_call/view/VideoCallPage.dart';
import 'package:smart_assistant/shared/widgets/button.dart';

import '../../dashboard/classes/Response.dart';

class QuickAction extends StatelessWidget {
  OggettoOggetto? ogg;
  QuickAction({
    required OggettoOggetto oggetto,
    Key? key,
    //required this.action,
  }) : super(key: key) {
    ogg = oggetto;
  }
  @override
  Widget build(BuildContext context) {
    var width = 120;
    var height = 55;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ButtonIconNoBG(
          label: 'Search',
          height: height.h,
          width: width.w,
          icon: Icons.search,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchView(oggetto: ogg!)),
            );
          },
          fontSize: 20.sp,
          iconSize: 28.sp,
        ),
        ButtonIconNoBG(
          label: 'Chatbot',
          height: height.h,
          width: width.w,
          icon: Icons.smart_toy,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatBot(oggetto: ogg!)),
            );
          },
          fontSize: 20.sp,
          iconSize: 28.sp,
        ),
        ButtonIconNoBG(
          label: 'Human Help',
          height: height.h,
          width: width.w,
          icon: Icons.engineering,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VideoCallPage()),
            );
          },
          fontSize: 20.sp,
          iconSize: 28.sp,
        ),
      ],
    );
  }
}
