import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_assistant/features/task_list/classes/Response.dart';
import '../../../../shared/res/res.dart';

class ToolList extends StatefulWidget {
  List<AttivitaRicambiTipoRicambio> ricambi;
  List<AttivitaTipoAttrezzaturaTipoAttrezzatura> attrezzatura;

  ToolList({
    super.key,
    required this.ricambi,
    required this.attrezzatura,
  }) {
    ricambi = ricambi;
    attrezzatura = attrezzatura;
  }

  @override
  State<ToolList> createState() => _ToolListState();
}

class _ToolListState extends State<ToolList> {
  List<String> tools = [];

  void fillList(){
    for (var i = 0; i < widget.attrezzatura.length; i++) {
      tools.add(widget.attrezzatura[i].nome);
    }
    for (var i = 0; i < widget.ricambi.length; i++) {
      tools.add(widget.ricambi[i].nome);
    }

    if(tools.length == 0){
      tools.add("Nessun elemento");
    }
  }

  @override
  Widget build(BuildContext context) {
    fillList();
    return Container(
      //dimensione
      height: 650.h,
      child: Scaffold(
        backgroundColor: SmartAssistantColors.white,
        body: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            return ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: SmartAssistantColors.secondary,
                    width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: SmartAssistantColors.secondary,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              leading: index <= widget.attrezzatura.length
                ? Icon(Icons.circle, color: Colors.green)
                : Icon(Icons.circle, color: Colors.red),
              title: Text(
                tools[index],
                style: TextStyles.body.copyWith(
                    fontSize: 18.sp,
                    color: SmartAssistantColors.black
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 10),
        ),
        ),
    );
  }
}
