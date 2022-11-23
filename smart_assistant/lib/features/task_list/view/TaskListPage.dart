import 'dart:developer';

import 'package:smart_assistant/features/task_list/classes/Response.dart';
import 'package:smart_assistant/features/task_list/widget/TaskList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/res/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class DataFromResponse {
  static Future<Response> getDataLocally(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data =
        await assetBundle.loadString('assets/images/jsonAttivita.json');
    final reportData = responseFromJson(data);

    return reportData;
  }
}

class _TaskListPageState extends State<TaskListPage> {
  List<Attivita> attivitas = [];

  static List<Map<String, dynamic>> jsonResponse =
      List<Map<String, dynamic>>.generate(
    10,
    (index) => {
      'codiceAttivita': '$index',
      'descrizione': 'descrizione $index',
      'durataPrevista': '$index',
      'priorita': 'priorita $index',
      'nome': 'nome $index',
    },
  );

  void getAttivitas() async {
    await DataFromResponse.getDataLocally(context).then((value) {
      setState(() {
        attivitas = value.data.attivitas;
      });
    });
    /*List<Attivita?> listAttivitas = [];
  int length = data?.data?.attivitas?.length ?? 0;
  for (var i = 0; i < length; i++) {
    final attivita = data?.data?.attivitas?.elementAt(i);
    listAttivitas.add(attivita);
  }
  attivitas = listAttivitas as List<Attivita>;*/
  }

  @override
  Widget build(BuildContext) {
    getAttivitas();
    return Scaffold(
      backgroundColor: SmartAssistantColors.secondary,
      body: Container(
        padding: EdgeInsets.only(top: 40.h, left: 10.w, right: 10.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => null,
                  child: Icon(
                    Icons.account_circle,
                    color: SmartAssistantColors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => null,
                  child: Icon(
                    Icons.notifications_outlined,
                    color: SmartAssistantColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 60,
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
            TaskList(attivitas: attivitas),
            //align button to the bottom
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 100.w,
                  height: 30.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: SmartAssistantColors.secondary,
                      backgroundColor: SmartAssistantColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => null,
                    child: const Text(
                      'Start task',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}
