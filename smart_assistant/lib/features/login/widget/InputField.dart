import 'package:flutter/material.dart';
import 'package:smart_assistant/shared/res/res.dart';

class InputField extends StatelessWidget {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  InputField(
      {super.key, required this.userController, required this.passController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: userController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            style: const TextStyle(fontSize: 28),
            decoration: InputDecoration(
                hintText: "Enter your email",
                hintStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? SmartAssistantColors.grey30
                      : SmartAssistantColors.white,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 25.0, horizontal: 10.0)),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: passController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }

              return null;
            },
            obscureText: true,
            style: const TextStyle(fontSize: 28),
            decoration: InputDecoration(
                hintText: "Enter your password",
                hintStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? SmartAssistantColors.grey30
                      : SmartAssistantColors.white,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 25.0, horizontal: 10.0)),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
