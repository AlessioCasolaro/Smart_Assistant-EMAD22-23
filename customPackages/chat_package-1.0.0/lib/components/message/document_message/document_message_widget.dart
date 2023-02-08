import 'dart:io';
import 'package:chat_package/utils/transparent_image.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_package/components/message/document_message/pdfView.dart';
import 'package:smart_assistant/features/dashboard/widgets/document.dart';

//TODO add text size
class DocumentMessageWidget extends StatelessWidget {
  /// chat message model to get teh data
  final ChatMessage message;

  ///the color of the sender container
  final Color senderColor;

  final TextStyle? messageContainerTextStyle;

  const DocumentMessageWidget({
    Key? key,
    required this.message,
    required this.senderColor,
    this.messageContainerTextStyle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          message.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: senderColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: message.isSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    /// navigate to to the photo gallery view, for viewing the taped image
                    Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (BuildContext context) => PdfView(
                          document:
                              Document(message.text, message.chatMedia!.url)),
                    ));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0 * 0.75,
                      vertical: 20.0 / 2,
                    ),
                    width: 320.w,
                    child: Row(children: [
                      Icon(Icons.picture_as_pdf, color: Colors.black),
                      SizedBox(width: 10),
                      Text("Open PDF",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500)),
                    ]),
                  )),
              Visibility(
                visible: message.text.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 8,
                    top: 8,
                    right: message.isSender ? 8 : 0,
                    left: message.isSender ? 0 : 8,
                  ),
                  child: Text(
                    message.text,
                    style:
                        messageContainerTextStyle ?? TextStyle(fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
