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
              child: SizedBox(
            width: 350,
            height: 350,
            child: Image.asset("assets/images/smartAssistantLogo.png"),
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
