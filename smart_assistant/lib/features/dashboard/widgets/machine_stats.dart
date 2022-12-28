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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: boxDecoration,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            Text(
              bearing1,
              style:
                  TextStyles.body.copyWith(color: SmartAssistantColors.white),
            ),
            Row(
              children: [
                const Icon(
                  Icons.graphic_eq,
                  size: 24,
                  color: SmartAssistantColors.white,
                ),
                Text(
                  "30 Hz",
                  style: TextStyles.body
                      .copyWith(color: SmartAssistantColors.white),
                ),
              ],
            )
          ],
        ),
        Column(
          children: [
            Text(
              bearing2,
              style:
                  TextStyles.body.copyWith(color: SmartAssistantColors.white),
            ),
            Row(
              children: [
                const Icon(
                  Icons.graphic_eq,
                  size: 24,
                  color: SmartAssistantColors.white,
                ),
                Text(
                  '80 Hz',
                  style: TextStyles.body
                      .copyWith(color: SmartAssistantColors.white),
                ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            Text(
              bearing3,
              style:
                  TextStyles.body.copyWith(color: SmartAssistantColors.white),
            ),
            Row(
              children: [
                const Icon(
                  Icons.graphic_eq,
                  size: 24,
                  color: SmartAssistantColors.white,
                ),
                Text(
                  '250 Hz',
                  style: TextStyles.body
                      .copyWith(color: SmartAssistantColors.white),
                ),
              ],
            )
          ],
        ),
        Column(
          children: [
            Text(
              bearing4,
              style:
                  TextStyles.body.copyWith(color: SmartAssistantColors.white),
            ),
            Row(
              children: [
                const Icon(
                  Icons.graphic_eq,
                  size: 24,
                  color: SmartAssistantColors.white,
                ),
                Text(
                  '230 Hz',
                  style: TextStyles.body
                      .copyWith(color: SmartAssistantColors.white),
                ),
              ],
            )
          ],
        ),
      ]),
    );
  }
}
