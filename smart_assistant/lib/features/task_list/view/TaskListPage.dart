import 'package:smart_assistant/features/qr/views/qrScanner.dart';
import 'package:smart_assistant/features/task_list/classes/Response.dart';
import 'package:smart_assistant/features/task_list/widget/TaskList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_assistant/shared/widgets/button.dart';
import '../../../../shared/res/res.dart';
import 'package:flutter/material.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();

  static _TaskListPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_TaskListPageState>();
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
  int selectedIndex = 999;

  void getAttivitas() async {
    await DataFromResponse.getDataLocally(context).then((value) {
      setState(() {
        attivitas = value.data.attivitas;
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
    getAttivitas();
    sortAttivitas();
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
                  child: Icon(
                    Icons.account_circle,
                    size: 70,
                    color: SmartAssistantColors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => null,
                  child: Icon(
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
            TaskList(
                callback: (index) => setState(() => selectedIndex = index),
                attivitas: attivitas),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 100.w,
                  height: 55.h,
                  child: ButtonPrimary(
                      label: 'Next',
                      width: 100.w,
                      height: 55.h,
                      fontSize: 24,
                      onPressed: () {
                        Attivita toPass = attivitas[selectedIndex];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QRScanner(key: null, selectedAttivita: toPass),
                          ),
                        );
                      }),
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
