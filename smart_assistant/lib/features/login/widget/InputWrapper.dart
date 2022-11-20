import 'package:flutter/material.dart';
import 'package:smart_assistant/core/navigator.dart';
import 'package:smart_assistant/features/dashboard/views/home.dart';
import 'package:smart_assistant/shared/res/colors.dart';
import 'package:smart_assistant/shared/widgets/button.dart';

import '../../task_list/view/TaskListPage.dart';
import '../widget/InputField.dart';

class InputWrapper extends StatefulWidget {
  const InputWrapper({super.key});

  @override
  InputState createState() {
    return InputState();
  }
}

class InputState extends State<InputWrapper> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 40,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: SmartAssistantColors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: const InputField(),
                ),
                const SizedBox(
                  height: 30,
                ),
                ButtonPrimary(
                  label: "Login",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar and navigate to the task list page.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logging in...')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TaskListPage()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
