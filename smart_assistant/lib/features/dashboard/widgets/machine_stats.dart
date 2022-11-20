import 'dart:ffi';

import 'package:flutter/material.dart';
import '../../../../shared/res/res.dart';

class MachineStats extends StatelessWidget {
  const MachineStats({
    this.boxDecoration,
    Key? key,
  }) : super(key: key);

  final BoxDecoration? boxDecoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: boxDecoration,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            Text(
              'Temperature',
              style:
                  TextStyles.body.copyWith(color: SmartAssistantColors.white),
            ),
            Row(
              children: [
                Icon(
                  Icons.thermostat,
                  size: 24,
                  color: SmartAssistantColors.white,
                ),
                Text(
                  '23°C',
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
              'Pressure',
              style:
                  TextStyles.body.copyWith(color: SmartAssistantColors.white),
            ),
            Row(
              children: [
                Icon(
                  Icons.air,
                  size: 24,
                  color: SmartAssistantColors.white,
                ),
                Text(
                  '80%',
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
              'Energy Consumption',
              style:
                  TextStyles.body.copyWith(color: SmartAssistantColors.white),
            ),
            Row(
              children: [
                Icon(
                  Icons.bolt_sharp,
                  size: 24,
                  color: SmartAssistantColors.white,
                ),
                Text(
                  '250 KWh',
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
