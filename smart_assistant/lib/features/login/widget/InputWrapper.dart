import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:smart_assistant/shared/widgets/button.dart';

import '../../../shared/res/colors.dart';
import '../../../shared/res/typography.dart';
import '../../task_list/view/TaskListPage.dart';
import '../widget/InputField.dart';

import 'package:get/get.dart' as getPackage;

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
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        child: InputField(
                            userController: userController,
                            passController: passController),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ButtonPrimary(
                        label: "Login",
                        width: 100.w,
                        height: 50.h,
                        fontSize: 30.sp,
                        onPressed: () async {
                          if ((passController.text ==
                                  await readData(userController.text)) &
                              _formKey.currentState!.validate()) {
                            codiceUtente = await readUser(userController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TaskListPage(utente: codiceUtente)),
                            );
                          } else {
                            CherryToast.error(
                                    title: Text("Login error!",
                                        style: TextStyle(
                                          color: SmartAssistantColors.red,
                                          fontSize: 18.sp,
                                        )),
                                    description:
                                        Text("Wrong username or password!"),
                                    toastPosition: Position.bottom,
                                    animationType: AnimationType.fromTop,
                                    autoDismiss: true)
                                .show(context);
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
