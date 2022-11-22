import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_assistant/features/task_list/classes/Response.dart';
//import 'pdfView.dart';
import '../../../../shared/res/res.dart';

class TaskList extends StatefulWidget {
  List<Attivita> attivitas = [];
  //List<Map<String, dynamic>> taskJson;
  //List<Task> taskList = <Task>[];

  TaskList({
    super.key,
    required this.attivitas,
  }) {
    /*for (var i = 0; i < taskJson.length; i++) {
      taskList = List<Task>.generate(
          taskJson.length, (i) => Task.fromJson(taskJson[i]));
    } */
  } 

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<bool> _selected = [];

  @override
  Widget build(BuildContext context) {
    setState(() {
      if(_selected.length != widget.attivitas.length) {
        _selected = List<bool>.generate(widget.attivitas.length, (i) => false);
      }
    });
    return Container(
      //dimensione
      height: 650.h,
      child: Scaffold(
        backgroundColor: SmartAssistantColors.secondary,
        body: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: widget.attivitas.length,
          itemBuilder: (context, index) {
            return ListTile(
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(color: SmartAssistantColors.secondary, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: _selected[index]
                  ? SmartAssistantColors.primary
                  : SmartAssistantColors.grey30,
              visualDensity: VisualDensity(horizontal: 0, vertical: 4),
              leading: const Icon(Icons.work_outline, color: Colors.black),
              title: Text(
                widget.attivitas[index].nome,
                style: TextStyles.body.copyWith(
                    fontSize: 18.sp, color: SmartAssistantColors.black),
              ),
              onTap: () {
                setState(() {
                  for (var i = 0; i < widget.attivitas.length; i++) {
                    if (i == index) {
                      _selected[i] = true;
                    } else {
                      _selected[i] = false;
                    }
                  }
                });
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      ),
    );
  }
}
