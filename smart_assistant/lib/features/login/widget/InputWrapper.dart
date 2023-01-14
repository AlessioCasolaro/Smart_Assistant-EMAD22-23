import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_assistant/core/navigator.dart';
import 'package:smart_assistant/features/dashboard/views/home.dart';
import 'package:smart_assistant/features/video_call/view/VideoCallPage.dart';
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
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String codiceUtente = "";
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
                  child: InputField(
                      userController: userController,
                      passController: passController),
                ),
                const SizedBox(
                  height: 30,
                ),
                ButtonPrimary(
                  label: "Login",
                  width: 130,
                  height: 80,
                  fontSize: 30,
                  onPressed: () async {
                    //log("message" +myController.text +"pass" +await readData());
                    if ((passController.text ==
                            await readData(userController.text)) &
                        _formKey.currentState!.validate()) {
                      codiceUtente = await readUser(userController.text);
                      log("Login ok");
                      // If the form is valid, display a snackbar and navigate to the task list page.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: SmartAssistantColors.secondary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            content: Text(
                              'Logged in successfully',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.black),
                            )),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TaskListPage(utente: codiceUtente)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            content: Text(
                              'Wrong username or password',
                              style: TextStyle(fontSize: 25),
                            )),
                      );
                    }
                    log("Login not ok");
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

Future<String> readData(String user) async {
  DatabaseReference reference =
      // FirebaseDatabase.instance.ref().child("users").child(user).child("name");
      FirebaseDatabase.instance.ref().child("password");
  DatabaseEvent event = await reference.once();
  //log(event.snapshot.value.toString());
  return event.snapshot.value.toString();
}

Future<String> readUser(String user) async {
  DatabaseReference reference =
      // FirebaseDatabase.instance.ref().child("users").child(user).child("name");
      FirebaseDatabase.instance.ref().child("codiceUtente");
  DatabaseEvent event = await reference.once();
  //log(event.snapshot.value.toString());
  return event.snapshot.value.toString();
}
