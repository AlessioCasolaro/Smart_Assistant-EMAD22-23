import 'package:flutter/material.dart';
import 'package:smart_assistant/shared/widgets/button.dart';

import '../widget/InputField.dart';

class InputWrapper extends StatelessWidget {
  const InputWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: const InputField(),
            ),
            const SizedBox(
              height: 40,
            ),
            ButtonPrimary(label: "Login", onPressed: () => null),
          ],
        ),
      ),
    );
  }
}
