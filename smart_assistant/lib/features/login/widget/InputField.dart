import 'package:flutter/material.dart';
import 'package:smart_assistant/shared/res/res.dart';

class InputField extends StatelessWidget {
  const InputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: const TextField(
            style: TextStyle(fontSize: 24),
            decoration: InputDecoration(
                hintText: "Enter your email",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: const TextField(
            style: TextStyle(fontSize: 24),
            decoration: InputDecoration(
                hintText: "Enter your password",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
          ),
        ),
        Container(
          height: 20,
        ),
        Container(
          width: 200,
          height: 1,
          color: SmartAssistantColors.grey,
        ),
      ],
    );
  }
}
