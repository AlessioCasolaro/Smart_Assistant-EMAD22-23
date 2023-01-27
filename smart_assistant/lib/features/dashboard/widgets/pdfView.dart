import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_assistant/features/dashboard/widgets/widgets.dart';
import 'package:smart_assistant/shared/res/res.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../classes/Response.dart';

class PdfView extends StatelessWidget {
  OggettoOggetto? machine;
  final Document document;

  PdfView({
    Key? key,
    required OggettoOggetto oggetto,
    required this.document,
  }) : super(key: key) {
    machine = oggetto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(document.name),
        backgroundColor: SmartAssistantColors.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          MachineStats(
              macchina: machine!,
              box: const BoxDecoration(color: Color(0xFF1F75FE))),
          SizedBox(height: 10.h),
          SizedBox(
              height: MediaQuery.of(context).size.height - 155.h,
              child: SfPdfViewer.network(document.url)),
        ],
      ),
    );
  }
}
