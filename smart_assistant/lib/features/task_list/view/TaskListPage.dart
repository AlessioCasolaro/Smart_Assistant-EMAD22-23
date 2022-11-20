import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_assistant/features/task_list/widget/Task.dart';
import 'package:smart_assistant/features/task_list/widget/TasksList.dart';
//import 'package:smarty/features/home/presentation/widgets/machine_info.dart';
//import '../../../../core/navigation/navigator.dart';

import '../../../../shared/res/res.dart';
//import '../../../devices/domain/models/devices.dart';
import '../widget/TasksList.dart';
//import '../widgets/widgets.dart';

class TaskListPage extends StatelessWidget {
  static List<String> docList = ['Doc1', 'Doc2', 'Doc3', 'Doc4']; //PROVA
  static List<String> urlList = [
    'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
    'https://www.africau.edu/images/default/sample.pdf',
    'Url3',
    'Url4'
  ]; //PROVA
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext) {
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
                  child: const CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                ),
                GestureDetector(
                  onTap: () => null,
                  child: const CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage('assets/images/profile.png'),
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
                  style: GoogleFonts.roboto(
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
          ],
        ),
      ),
    );
  }

  /*@override
   Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 32.h + MediaQuery.of(context).padding.top),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => null,
                child: const CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                /*Navigator.pushNamed(
                  profileRoute,
                  arguments: Icon(
                    Icons.notifications_outlined,
                    color: SmartAssistantColors.grey,
                  ),
                ), 
                child: const CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ), */
              ),
              Icon(
                Icons.notifications,
                size: 64,
                color: SmartAssistantColors.black,
              ),
            ],
          ),
          //SizedBox(height: 32.h),
          //const MachineInfo(),
          //
          //SizedBox(height: 16.h),
          //const SummaryHeader(),
          //
          //SizedBox(height: 16.h),
          //const QuickAction(),

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

          TasksList(
            document: List.generate(
              4,
              (i) => Task(
                'Documento ' + docList[i],
                urlList[i],
              ),
            ),
          ),

          //Align button to bottom
          SizedBox(height: 32.h),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 120.w,
              height: 55.h,
              child: ElevatedButton(
                onPressed: () => null,
                child: Row(
                  children: [
                    Icon(
                      Icons.done,
                      size: 36,
                      color: SmartAssistantColors.secondary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Complete Task',
                      style: TextStyles.body.copyWith(
                        fontSize: 18.sp,
                        color: SmartAssistantColors.secondary,
                      ),
                    ),
                  ],
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(SmartAssistantColors.primary),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /*
          SizedBox(height: 32.h),
          Text(
            'Active Devices',
            style: TextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: SmartyColors.grey,
            ),
          ),
          SizedBox(height: 16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [...devices.map((e) => DeviceCard(device: e))],
            ),
          ),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rooms',
                style: TextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: SmartyColors.grey,
                ),
              ),
              Text(
                'Edit',
                style: TextStyles.body.copyWith(
                  color: SmartyColors.grey60,
                ),
              )
            ],
          ),
          SizedBox(height: 16.h),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 100,
                ),
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) {
                  return const RoomCard();
                }),
          ),*/
        ]),
      ),
    );
  } */
}
