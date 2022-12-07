import 'package:flutter/material.dart';
import 'package:smart_assistant/features/task_list/classes/Response.dart';
import '../../../../shared/res/res.dart';
import '../../../core/navigator.dart';

class MachineInfo extends StatelessWidget {
  OggettoOggetto? machine;
  String serialNumber = '1234567890';

  MachineInfo({Key? key, required OggettoOggetto macchina}) : super(key: key) {
    machine = macchina;
    serialNumber = machine!.codiceOggetto;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNavigator.pushNamed(''),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        //crea un child con 3 righe contenenti un testo
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '${machine!.nome}',
                  style: TextStyles.body.copyWith(
                      color: SmartAssistantColors.primary,
                      fontSize: TextStyles.headline2.fontSize),
                ),
              ],
            ),
            //Riga 2 colonne
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'S/N',
                      style: TextStyles.body.copyWith(
                          color: SmartAssistantColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: TextStyles.body.fontSize),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text('$serialNumber',
                        style: TextStyle(fontSize: TextStyles.body.fontSize))
                  ],
                ),
              ],
            ),
            //Riga 2 colonne
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Last Maintenance',
                      style: TextStyles.body.copyWith(
                          color: SmartAssistantColors.primary,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '10/10/2021',
                      style: TextStyle(fontSize: TextStyles.body.fontSize),
                    )
                  ],
                ),
              ],
            ), //Riga 2 colonne
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Status',
                      style: TextStyles.body.copyWith(
                          color: SmartAssistantColors.primary,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Working',
                      style: TextStyle(fontSize: TextStyles.body.fontSize),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
