import 'package:flutter/material.dart';
import 'package:smart_assistant/shared/res/colors.dart';
import 'package:smart_assistant/shared/res/typography.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
              child: CircleAvatar(
            backgroundColor: SmartAssistantColors.white,
            radius: 150,
            child: Container(
              child: Image.asset(
                'assets/images/smartAssistantLogo.png',
                width: 220.w,
                height: 220.h,
              ),
            ),
          )),
          SizedBox(
            height: 20.h,
          ),
          Center(
            child: Text(
              "LOGIN",
              style: TextStyle(
                  color: SmartAssistantColors.white,
                  fontSize: TextStyles.headline1.fontSize),
            ),
          ),
        ],
      ),
    );
  }
}
