import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

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
    final data = await getData("503");
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
    await DataFromResponse.getDataLocally(context).then((value) {
      setState(() {
        istanze = value.data.istanzaAttivitas;
        for (int i = 0; i < istanze.length; i++) {
          attivitas.add(istanze[i].attivitaAttivitas);
        }
      });
    });
  }

  //ordinamento attivitas per priorità
  void sortAttivitas() {
    attivitas.sort((a, b) {
      if (a.priorita == "ALTA" && b.priorita == "ALTA") {
        return 0;
      } else if (a.priorita == "ALTA" && b.priorita == "NORMALE") {
        return -1;
      } else if (a.priorita == "ALTA" && b.priorita == "BASSA") {
        return -1;
      } else if (a.priorita == "NORMALE" && b.priorita == "ALTA") {
        return 1;
      } else if (a.priorita == "NORMALE" && b.priorita == "NORMALE") {
        return 0;
      } else if (a.priorita == "NORMALE" && b.priorita == "BASSA") {
        return -1;
      } else if (a.priorita == "BASSA" && b.priorita == "ALTA") {
        return 1;
      } else if (a.priorita == "BASSA" && b.priorita == "NORMALE") {
        return 1;
      } else if (a.priorita == "BASSA" && b.priorita == "BASSA") {
        return 0;
      } else {
        return 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      getAttivitas();
      sortAttivitas();
      count++;
    }

    return Scaffold(
      backgroundColor: SmartAssistantColors.white,
      body: Container(
        padding: EdgeInsets.only(top: 40.h, left: 10.w, right: 10.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => null,
                  child: const Icon(
                    Icons.account_circle,
                    size: 70,
                    color: SmartAssistantColors.black,
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
                    color: SmartAssistantColors.black,
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
                    color: SmartAssistantColors.black,
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
                                    builder: (context) =>
                                        ToolListPage(selectedAttivita: toPass)),
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
}
