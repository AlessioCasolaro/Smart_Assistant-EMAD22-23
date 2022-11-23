import 'package:flutter/material.dart';
import 'package:smart_assistant/features/dashboard/widgets/widgets.dart';
import 'package:smart_assistant/shared/res/res.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatelessWidget {
  final Document document;

  const PdfView({
    Key? key,
    required this.document,
  }) : super(key: key);
  // Declare a field that holds the Todo.

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
          const MachineStats(
              boxDecoration: BoxDecoration(color: Color(0xFF1F75FE))),
          const SizedBox(height: 10),
          SizedBox(
              height: MediaQuery.of(context).size.height - 170,
              child: SfPdfViewer.network(document.url)),
        ],
      ),
    );
  }
}
