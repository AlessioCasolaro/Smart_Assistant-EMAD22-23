import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Task.dart';
//import 'pdfView.dart';
import '../../../../shared/res/res.dart';

class TaskList extends StatefulWidget {
  List<String> taskJson = List<String>.generate(10, (i) => "Task $i");

  @override
  _TaskListState createState() => new _TaskListState();

  TaskList({
    Key? key,
    required this.taskJson,
  }) : super(key: key);

}

class _TaskListState extends State<TaskList> {

  bool loading = true;

  _TaskListState(){
    widget.taskJson.then((List value) {

      // loop through the json object
      for (var i = 0; i < value.length; i++) {

        // add the ListTile to an array
        listArray.add(new ListTile(title: new Text(value[i].name));

        }

            //use setState to refresh UI
            setState((){
          loading = false;
        });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //dimensione
      height: 300.h,
      child: Scaffold(
        body: ListView.separated(
          itemCount: document.length,
          itemBuilder: (context, index) {
            return ListTile(
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(color: SmartAssistantColors.secondary, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              tileColor: SmartAssistantColors.secondary,
              visualDensity: VisualDensity(horizontal: 0, vertical: 4),
              leading: const Icon(Icons.picture_as_pdf, color: Colors.black),
              title: Text(
                document[index].title,
                style: TextStyles.body.copyWith(
                    fontSize: 18.sp, color: SmartAssistantColors.black),
              ),
              //onTap: () {
              //Navigator.push(
              //context,
              //MaterialPageRoute(
              //builder: (context) => PdfView(document: document[index]),
              //),
              //);
              //},
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      ),
    );
  }
}
