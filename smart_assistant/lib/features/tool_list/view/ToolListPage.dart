import 'package:smart_assistant/features/qr/views/qrScanner.dart';
import 'package:smart_assistant/features/task_list/classes/Response.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_assistant/features/tool_list/widget/ToolList.dart';
import 'package:smart_assistant/shared/widgets/button.dart';
import '../../../../shared/res/res.dart';
import 'package:flutter/material.dart';

class ToolListPage extends StatefulWidget {
  Attivita? attivita;
  List<AttivitaRicambiTipoRicambio>? ricambi;
  List<AttivitaTipoAttrezzaturaTipoAttrezzatura>? attrezzatura;
  
  ToolListPage({Key? key, required Attivita selectedAttivita}) : super(key: key) {
    attivita = selectedAttivita;
    ricambi = selectedAttivita.attivitaRicambiTipoRicambios;
    attrezzatura = selectedAttivita.attivitaTipoAttrezzaturaTipoAttrezzaturas;
  }

  @override
  _ToolListPageState createState() => _ToolListPageState();
}

class _ToolListPageState extends State<ToolListPage> {
  @override
  Widget build(BuildContext context) {
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
              children: [
            Text(
              'Attrezzatura e ricambi',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.w700,
                color: SmartAssistantColors.black,
              ),
          ),
              ],),
          const SizedBox(
              height: 20,
            ),
            ToolList(ricambi: widget.attivita!.attivitaRicambiTipoRicambios,
            attrezzatura: widget.attivita!.attivitaTipoAttrezzaturaTipoAttrezzaturas),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 70.h,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.circle, color: Colors.green),
                        Text(
                          'Attrezzatura',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: SmartAssistantColors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.circle, color: Colors.red),
                        Text(
                          'Ricambi',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: SmartAssistantColors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QRScanner(key: null, selectedAttivita: widget.attivita!),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
