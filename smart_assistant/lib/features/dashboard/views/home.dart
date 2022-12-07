import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_assistant/features/task_list/classes/Response.dart';
import 'package:smart_assistant/shared/widgets/button.dart';
import '../../../../shared/res/res.dart';
import '../../../core/navigator.dart';
import '../../../shared/widgets/backAlert.dart';
import '../widgets/documentsList.dart';
import '../widgets/widgets.dart';

class Dashboard extends StatelessWidget {
  AttivitaAttivitas? attivita;
  static List<String> docList = ['Doc1', 'Doc2', 'Doc3', 'Doc4']; //PROVA
  static List<String> urlList = [
    'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
    'https://www.africau.edu/images/default/sample.pdf',
    'Url3',
    'Url4'
  ]; //PROVA

  Dashboard({Key? key, required AttivitaAttivitas startedAttivita})
      : super(key: key) {
    attivita = startedAttivita;
  }

  @override
  Widget build(BuildContext context) {
    return BackAlert(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 32.h + MediaQuery.of(context).padding.top),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => AppNavigator.pushNamed(
                      dashboardRoute,
                      arguments: Icon(
                        Icons.notifications_outlined,
                        color: SmartAssistantColors.grey,
                      ),
                    ),
                    child: const Icon(Icons.account_circle, size: 75),
                  ),
                  Icon(
                    Icons.notifications,
                    size: 64,
                    color: SmartAssistantColors.black,
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              MachineInfo(
                macchina: attivita!.oggettoOggettos[0],
              ),
              //
              SizedBox(height: 16.h),
              const MachineStats(
                  boxDecoration: BoxDecoration(
                      color: Color(0xFF1F75FE),
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              //
              SizedBox(height: 16.h),
              const QuickAction(),

              SizedBox(height: 32.h),
              //Titolo al centro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Documents',
                    style: TextStyles.body.copyWith(
                      fontSize: TextStyles.headline2.fontSize,
                      color: SmartAssistantColors.primary,
                    ),
                  )
                ],
              ),

              DocumentsList(
                document: List.generate(
                  4,
                  (i) => Document(
                    'Documento ' + docList[i],
                    urlList[i],
                  ),
                ),
              ),

              //Align button to bottom
              //SizedBox(height: 32.h),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                    width: 130.w,
                    height: 55.h,
                    child: ButtonIconPrimary(
                      label: 'Complete Task',
                      height: 130.h,
                      width: 80.w,
                      icon: Icons.done,
                      onPressed: () {},
                    )),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
