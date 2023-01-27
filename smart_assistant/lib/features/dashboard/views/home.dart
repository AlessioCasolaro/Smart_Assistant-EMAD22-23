import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_assistant/shared/widgets/button.dart';
import '../../../../shared/res/res.dart';
import '../../../core/navigator.dart';
import '../../../shared/widgets/backAlert.dart';
import '../../notification/view/notification.dart';
import '../widgets/documentsList.dart';
import '../widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart' as getPackage;

import 'package:smart_assistant/features/dashboard/classes/Response.dart';

int count = 0;

class Dashboard extends StatefulWidget {
  String? attivita = "6";
  String? oggetto = "2";
  static List<String> docList = [];
  static List<String> urlList = [];

  Dashboard({Key? key, required startedAttivita, required selectedOggetto})
      : super(key: key) {
    attivita = startedAttivita;
    oggetto = selectedOggetto;
  }

  @override
  State<Dashboard> createState() => _DashboardState();
}

Future loaddot() async {
  await dotenv.load(fileName: ".env");
}

Future<http.Response> getData(String codAttivita, String codOggetto) {
  return http.post(
    Uri.parse(dotenv.env['URL_DASHBOARD'].toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'codiceAttivita': codAttivita,
      'codiceOggetto': codOggetto,
    }),
  );
}

class DataFromResponse {
  static Future<ResponseDashboard> getDataLocally(
      BuildContext context, String codAttivita, String codOggetto) async {
    final data = await getData(codAttivita, codOggetto);
    final reportData = responseFromJsonDashboard(data.body);

    log("Log Dashboard" + data.body.toString());
    return reportData;
  }
}

class _DashboardState extends State<Dashboard> {
  late List<Attivita> attivita;
  List<OggettoOggetto> oggetto = [];
  Future<void> getAttivitas() async {
    await DataFromResponse.getDataLocally(
            context, widget.attivita!, widget.oggetto!)
        .then((value) {
      setState(() {
        attivita = value.data.attivitas;
        for (int i = 0; i < attivita.length; i++) {
          oggetto.add(attivita[i].oggettoOggettos[0]);
        }
      });
    });
  }

  void fillDocList() {
    for (int i = 0; i < oggetto[0].contenutosOggetto.length; i++) {
      Dashboard.docList.add(oggetto[0].contenutosOggetto[i].titolo);
      Dashboard.urlList
          .add(oggetto[0].contenutosOggetto[i].riferimentoDocumentale);
    }
  }

  @override
  void initState() {
    if (count == 0) {
      getAttivitas().whenComplete(() => fillDocList());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: oggetto.isEmpty
          ? Scaffold(
              body: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const <Widget>[
                  SizedBox(height: 300.0),
                  SizedBox(
                    child: CircularProgressIndicator(
                        strokeWidth: 5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            SmartAssistantColors.primary)),
                    height: 100.0,
                    width: 100.0,
                  ),
                  SizedBox(height: 50.0),
                  Text(
                    'Loading task selected...',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: SmartAssistantColors.primary,
                    ),
                  ),
                ])))
          : BackAlert(
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height:
                                  32.h + MediaQuery.of(context).padding.top),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  getPackage.Get.isDarkMode
                                      ? getPackage.Get.changeTheme(
                                          ThemeData.light())
                                      : getPackage.Get.changeTheme(
                                          ThemeData.dark());
                                },
                                child: getPackage.Get.isDarkMode
                                    ? const Icon(
                                        Icons.light_mode,
                                        size: 70,
                                        //color: SmartAssistantColors.black,
                                      )
                                    : const Icon(
                                        Icons.dark_mode,
                                        size: 70,
                                        //color: SmartAssistantColors.black,
                                      ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationView(),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.notifications_outlined,
                                  size: 70,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32.h),
                          MachineInfo(
                            macchina: oggetto[0],
                          ),
                          //
                          SizedBox(height: 16.h),
                          MachineStats(
                            macchina: oggetto[0],
                            box: const BoxDecoration(
                                color: Color(0xFF1F75FE),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          //
                          SizedBox(height: 16.h),
                          QuickAction(oggetto: oggetto[0]),

                          SizedBox(height: 16.h),
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
                            heightGet: 330.h,
                            oggetto: oggetto[0],
                            document: List.generate(
                              Dashboard.docList.length,
                              (i) => Document(
                                'Documento ' + Dashboard.docList[i],
                                Dashboard.urlList[i],
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                                width: 150.w,
                                height: 50.h,
                                child: ButtonIconPrimary(
                                  label: 'Complete Task',
                                  height: 130.h,
                                  width: 0.w,
                                  icon: Icons.done,
                                  onPressed: () {},
                                )),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
    );
  }
}
