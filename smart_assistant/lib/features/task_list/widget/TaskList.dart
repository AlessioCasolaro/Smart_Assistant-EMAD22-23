// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Task.dart';
//import 'pdfView.dart';
import '../../../../shared/res/res.dart';

class TaskList extends StatefulWidget {
  List<Map<String, dynamic>> taskJson = List<Map<String, dynamic>>.generate(
    10,
    (index) => {
      'title': 'Task $index',
      'description': 'Description $index',
    },
  );

  TaskList({
    super.key,
    required this.taskJson,
  }) {
    for (var i = 0; i < taskJson.length; i++) {
      taskList = List<Task>.generate(
          taskJson.length, (i) => Task.fromJson(taskJson[i]));
    }
  }

  List<Task> taskList = <Task>[];

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final List<bool> _selected = List.generate(20, (i) => false);

  @override
  Widget build(BuildContext context) {
    return Container(
      //dimensione
      height: 650.h,
      child: Scaffold(
        backgroundColor: SmartAssistantColors.secondary,
        body: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: widget.taskJson.length,
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
                widget.taskList[index].title,
                style: TextStyles.body.copyWith(
                    fontSize: 18.sp, color: SmartAssistantColors.black),
              ),
              onTap: () {
                setState(() {
                  for (var i = 0; i < widget.taskJson.length; i++) {
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
