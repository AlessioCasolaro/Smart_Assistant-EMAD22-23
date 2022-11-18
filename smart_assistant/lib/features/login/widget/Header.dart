import 'package:flutter/material.dart';
import 'package:smart_assistant/shared/res/colors.dart';
import 'package:smart_assistant/shared/res/typography.dart';

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
            radius: 200,
            child: Container(
              child: Image.asset(
                'assets/images/smartAssistantLogo.png',
                width: 380,
                height: 380,
              ),
            ),
          )),
          Center(
            child: Text(
              "Login",
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
