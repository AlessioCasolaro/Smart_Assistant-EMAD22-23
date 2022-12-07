import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_assistant/features/task_list/classes/Response.dart';
import '../../../../shared/res/res.dart';
import '../view/TaskListPage.dart';

typedef void StringCallback(int index);

class TaskList extends StatefulWidget {
  List<AttivitaAttivitas> attivitas = [];
  final StringCallback callback;

  TaskList({
    super.key,
    required this.attivitas,
    required this.callback,
  }) {}

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<bool> _selected = [];

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (_selected.length != widget.attivitas.length) {
        _selected = List<bool>.generate(widget.attivitas.length, (i) => false);
      }
    });
    return Container(
      //dimensione
      height: 650.h,
      child: Scaffold(
        backgroundColor: SmartAssistantColors.white,
        body: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: widget.attivitas.length,
          itemBuilder: (context, index) {
            return ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: _selected[index]
                        ? SmartAssistantColors.primary
                        : SmartAssistantColors.secondary,
                    width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: _selected[index]
                  ? SmartAssistantColors.primary
                  : SmartAssistantColors.secondary,
              //visualDensity: VisualDensity(horizontal: 0, vertical: 4),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              leading: widget.attivitas[index].priorita == "BASSA"
                  ? const Icon(Icons.circle, color: Colors.green)
                  : widget.attivitas[index].priorita == "NORMALE"
                      ? const Icon(Icons.circle, color: Colors.orange)
                      : widget.attivitas[index].priorita == "ALTA"
                          ? const Icon(Icons.circle, color: Colors.red)
                          : const Icon(Icons.circle, color: Colors.black),
              title: Text(
                widget.attivitas[index].nome,
                style: TextStyles.body.copyWith(
                    fontSize: 18.sp,
                    color: _selected[index]
                        ? SmartAssistantColors.white
                        : SmartAssistantColors.black),
              ),
              onTap: () {
                setState(() {
                  TaskListPage.of(context)?.selectedIndex = index;
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
