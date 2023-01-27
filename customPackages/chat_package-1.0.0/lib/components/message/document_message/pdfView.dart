import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_assistant/features/dashboard/widgets/widgets.dart';
import 'package:smart_assistant/shared/res/res.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatelessWidget {
  final Document document;

  PdfView({
    Key? key,
    required this.document,
  }) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(document.name),
        backgroundColor: SmartAssistantColors.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: SfPdfViewer.network(document.url)),
        ],
      ),
    );
  }
}
