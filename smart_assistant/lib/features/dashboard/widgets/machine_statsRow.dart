import 'package:flutter/material.dart';
import 'package:smart_assistant/features/dashboard/classes/Response.dart';
import '../../../../shared/res/res.dart';

class MachineStats extends StatelessWidget {
  OggettoOggetto? machine;
  BoxDecoration? boxDecoration;
  String bearing1 = "", bearing2 = "", bearing3 = "", bearing4 = "";

  MachineStats(
      {Key? key, required OggettoOggetto macchina, required BoxDecoration box})
      : super(key: key) {
    machine = macchina;
    boxDecoration = box;
    bearing1 = machine!.sensoresOggetto[3].nome;
    bearing2 = machine!.sensoresOggetto[2].nome;
    bearing3 = machine!.sensoresOggetto[1].nome;
    bearing4 = machine!.sensoresOggetto[0].nome;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 72, 8),
      decoration: boxDecoration,
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
                color: SmartAssistantColors.primary,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    "Bearing 1",
                    style: TextStyles.body.copyWith(
                        color: SmartAssistantColors.white, fontSize: 40),
                  ),
                ),
                SizedBox(width: 150),
                Text(
                  "30 Hz",
                  style: TextStyles.body.copyWith(
                      color: SmartAssistantColors.white, fontSize: 30),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 148,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.5),
                      ),
                      child: Icon(
                        Icons.graphic_eq,
                        color: SmartAssistantColors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 100,
            decoration: BoxDecoration(
                color: SmartAssistantColors.primary,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    "Bearing 2",
                    style: TextStyles.body.copyWith(
                        color: SmartAssistantColors.white, fontSize: 40),
                  ),
                ),
                SizedBox(width: 150),
                Text(
                  "80 Hz",
                  style: TextStyles.body.copyWith(
                      color: SmartAssistantColors.white, fontSize: 30),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 148,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.5),
                      ),
                      child: Icon(
                        Icons.graphic_eq,
                        color: SmartAssistantColors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 100,
            decoration: BoxDecoration(
                color: SmartAssistantColors.primary,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    "Bearing 3",
                    style: TextStyles.body.copyWith(
                        color: SmartAssistantColors.white, fontSize: 40),
                  ),
                ),
                SizedBox(width: 150),
                Text(
                  "250 Hz",
                  style: TextStyles.body.copyWith(
                      color: SmartAssistantColors.white, fontSize: 30),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 148,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.5),
                      ),
                      child: Icon(
                        Icons.graphic_eq,
                        color: SmartAssistantColors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 100,
            decoration: BoxDecoration(
                color: SmartAssistantColors.primary,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    "Bearing 4",
                    style: TextStyles.body.copyWith(
                        color: SmartAssistantColors.white, fontSize: 40),
                  ),
                ),
                SizedBox(width: 150),
                Text(
                  "230 Hz",
                  style: TextStyles.body.copyWith(
                      color: SmartAssistantColors.white, fontSize: 30),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 148,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.5),
                      ),
                      child: Icon(
                        Icons.graphic_eq,
                        color: SmartAssistantColors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
