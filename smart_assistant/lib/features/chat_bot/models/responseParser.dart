import 'dart:convert';

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

String responseToJson(Response data) => json.encode(data.toJson());

class Response {
  Response({
    required this.messages,
  });

  List<Message> messages;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    required this.content,
    required this.contentType,
    required this.imageResponseCard,
  });

  String content;
  String contentType;
  ImageResponseCard? imageResponseCard;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        content: json["content"] == null ? null : json["content"],
        contentType: json["contentType"],
        imageResponseCard: json["imageResponseCard"] == null
            ? null
            : ImageResponseCard.fromJson(json["imageResponseCard"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content == null ? null : content,
        "contentType": contentType,
        "imageResponseCard":
            imageResponseCard == null ? null : imageResponseCard!.toJson(),
      };
}

class ImageResponseCard {
  ImageResponseCard({
    required this.buttons,
    required this.title,
  });

  List<Button> buttons;
  String title;

  factory ImageResponseCard.fromJson(Map<String, dynamic> json) =>
      ImageResponseCard(
        buttons:
            List<Button>.from(json["buttons"].map((x) => Button.fromJson(x))),
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "buttons": List<dynamic>.from(buttons.map((x) => x.toJson())),
        "title": title,
      };
}

class Button {
  Button({
    required this.text,
    required this.value,
  });

  String text;
  String value;

  factory Button.fromJson(Map<String, dynamic> json) => Button(
        text: json["text"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "value": value,
      };
}
