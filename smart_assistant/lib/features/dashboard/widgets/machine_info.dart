import 'package:flutter/material.dart';
import 'package:smart_assistant/features/dashboard/classes/Response.dart';
import '../../../../shared/res/res.dart';
import '../../../core/navigator.dart';

class MachineInfo extends StatelessWidget {
  OggettoOggetto? machine;
  String type = "";

  MachineInfo({Key? key, required OggettoOggetto macchina}) : super(key: key) {
    machine = macchina;
    type = machine!.tipoOggettoTipoOggettos.nome;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      //crea un child con 3 righe contenenti un testo
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${machine!.nome.substring(0, 14)}',
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
                    'Type',
                    style: TextStyles.body.copyWith(
                        color: SmartAssistantColors.primary,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    '$type',
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
                    style: TextStyle(
                        fontSize: TextStyles.body.fontSize,
                        color: Colors.green),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
