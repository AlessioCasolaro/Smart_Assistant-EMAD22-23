import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' as getPackage;
import 'package:http/http.dart' as http;
import 'package:smart_assistant/features/notification/view/notification.dart';

import 'package:smart_assistant/features/task_list/classes/Response.dart';
import 'package:smart_assistant/features/task_list/widget/TaskList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_assistant/shared/widgets/button.dart';
import '../../../../shared/res/res.dart';
import 'package:flutter/material.dart';

import '../../tool_list/view/ToolListPage.dart';

int count = 0;
String codUtente = "";

class TaskListPage extends StatefulWidget {
  TaskListPage({required String utente, Key? key}) : super(key: key) {
    codUtente = utente;
  }

  @override
  _TaskListPageState createState() => _TaskListPageState();

  static _TaskListPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_TaskListPageState>();
}

Future loaddot() async {
  await dotenv.load(fileName: ".env");
}

Future<http.Response> getData(String codUtente) {
  return http.post(
    Uri.parse(dotenv.env['URL_TASKLIST'].toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'codiceUtente': codUtente,
    }),
  );
}

class DataFromResponse {
  static Future<Response> getDataLocally(BuildContext context) async {
    final data = await getData(codUtente);
    log("Utenza: " + codUtente);
    log("LOG1 " + data.body.toString());
    final reportData = responseFromJson(data.body);
    return reportData;
  }
}

class _TaskListPageState extends State<TaskListPage> {
  late List<IstanzaAttivita> istanze;
  int selectedIndex = 999;
  List<AttivitaAttivitas> attivitas = [];
  void getAttivitas() async {
    List<AttivitaAttivitas> sortedAttivitas = [];
    await DataFromResponse.getDataLocally(context).then((value) {
      setState(() {
        istanze = value.data.istanzaAttivitas;
        for (int i = 0; i < istanze.length; i++) {
          attivitas.add(istanze[i].attivitaAttivitas);
        }
        for(int i = 0; i < attivitas.length; i++){
          if(attivitas[i].priorita == "ALTA"){
            sortedAttivitas.add(attivitas[i]);
          }
        }
        for(int i = 0; i < attivitas.length; i++){
          if(attivitas[i].priorita == "NORMALE"){
            sortedAttivitas.add(attivitas[i]);
          }
        }
        for(int i = 0; i < attivitas.length; i++){
          if(attivitas[i].priorita == "BASSA"){
            sortedAttivitas.add(attivitas[i]);
          }
        }
        attivitas = sortedAttivitas;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      getAttivitas();
      count++;
    }

    return Scaffold(
      //backgroundColor: SmartAssistantColors.white,
      body: Container(
        padding: EdgeInsets.only(top: 40.h, left: 10.w, right: 10.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    getPackage.Get.isDarkMode
                        ? getPackage.Get.changeTheme(ThemeData.light())
                        : getPackage.Get.changeTheme(ThemeData.dark());
                  },
                  child: getPackage.Get.isDarkMode
                      ? const Icon(
                          Icons.light_mode,
                          size: 70,
                          //color: SmartAssistantColors.black,
                        )
                      : const Icon(
                          Icons.dark_mode,
                          size: 70,
                          //color: SmartAssistantColors.black,
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationView(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.notifications_outlined,
                    size: 70,
                    //color: SmartAssistantColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tasks',
                  style: TextStyle(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w700,
                    //color: SmartAssistantColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            attivitas.isNotEmpty
                ? TaskList(
                    callback: (index) => setState(() => selectedIndex = index),
                    date: istanze,
                    attivitas: attivitas)
                : Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const <Widget>[
                        SizedBox(height: 300.0),
                        SizedBox(
                          child: CircularProgressIndicator(
                              strokeWidth: 5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  SmartAssistantColors.primary)),
                          height: 100.0,
                          width: 100.0,
                        ),
                        SizedBox(height: 50.0),
                        Text(
                          'Loading your tasks...',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: SmartAssistantColors.primary,
                          ),
                        ),
                      ])),
            attivitas.isNotEmpty
                ? Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 100.w,
                        height: 55.h,
                        child: ButtonPrimary(
                            label: 'Next',
                            width: 100.w,
                            height: 55.h,
                            fontSize: 24,
                            onPressed: () {
                              count = 0;
                              AttivitaAttivitas toPass =
                                  attivitas[selectedIndex];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ToolListPage(
                                        codUtente: codUtente,
                                        codIstanzaAttivita:
                                            istanze[selectedIndex]
                                                .codiceIstanzaAttivita,
                                        selectedAttivita: toPass)),
                              );
                            }),
                      ),
                    ),
                  )
                : const SizedBox(),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  Future<String> readData(String user) async {
    DatabaseReference reference =
        // FirebaseDatabase.instance.ref().child("users").child(user).child("name");
        FirebaseDatabase.instance.ref().child("codiceUtente");
    DatabaseEvent event = await reference.once();
    //log(event.snapshot.value.toString());
    return event.snapshot.value.toString();
  }
}
