import 'package:flutter/material.dart';
import 'package:smart_assistant/shared/res/res.dart';
import '../widget/Header.dart';
import '../widget/InputWrapper.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [Color(0xFF1F75FE), Color(0xFF1F75FE)]),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 60,
            ),
            const Header(),
            SizedBox(
              height: 50,
              child: Container(
                  decoration: const BoxDecoration(
                      color: SmartAssistantColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ))),
            ),
            Expanded(
                child: Container(
              decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  )),
              child: const InputWrapper(),
            ))
          ],
        ),
      ),
    );
  }
}
