import 'package:flutter/material.dart';
import 'package:smart_assistant/shared/res/res.dart';

class InputField extends StatefulWidget {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  InputField(
      {super.key, required this.userController, required this.passController});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: widget.userController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            style: const TextStyle(fontSize: 28),
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                prefixIconColor: SmartAssistantColors.primary,
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
            keyboardType: TextInputType.text,
            obscureText: !_passwordVisible, //This will obscure text dynamically
            controller: widget.passController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }

              return null;
            },
            style: const TextStyle(fontSize: 28),
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: SmartAssistantColors.primary,
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
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
