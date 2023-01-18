import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_assistant/features/dashboard/widgets/videoPlayer.dart';
import '../classes/Response.dart';
import 'document.dart';
import 'pdfView.dart';
import '../../../../shared/res/res.dart';

class DocumentsList extends StatelessWidget {
  final List<Document> document;
  OggettoOggetto? machine;
  DocumentsList({
    Key? key,
    required this.document,
    required OggettoOggetto oggetto,
  }) : super(key: key) {
    machine = oggetto;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350.h,
      child: Scaffold(
        body: ListView.separated(
          itemCount: document.length,
          itemBuilder: (context, index) {
            return ListTile(
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(color: SmartAssistantColors.secondary, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              tileColor: SmartAssistantColors.secondary,
              //visualDensity: const VisualDensity(horizontal: 0, vertical: 4),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              leading: document[index].url.contains("youtu")
                  ? const Icon(Icons.smart_display, color: Colors.black)
                  : const Icon(Icons.picture_as_pdf, color: Colors.black),
              title: Text(
                document[index].name,
                style: TextStyles.body.copyWith(
                    fontSize: 18.sp, color: SmartAssistantColors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => document[index].url.contains("youtu")
                        ? YoutubeVideoPlayer(
                            titleGet: document[index].name,
                            urlGet: document[index].url,
                            oggetto: machine!)
                        : PdfView(oggetto: machine!, document: document[index]),
                  ),
                );
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      ),
    );
  }
}
