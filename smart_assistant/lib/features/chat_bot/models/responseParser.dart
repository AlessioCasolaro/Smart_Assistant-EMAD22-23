// To parse this JSON data, do
//
//     final response = responseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

String responseToJson(Response data) => json.encode(data.toJson());

class Response {
  Response({
    required this.interpretations,
    required this.messages,
    required this.sessionId,
    required this.sessionState,
  });

  List<Interpretation> interpretations;
  List<Message> messages;
  int sessionId;
  SessionState sessionState;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        interpretations: List<Interpretation>.from(
            json["interpretations"].map((x) => Interpretation.fromJson(x))),
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
        sessionId: json["sessionId"],
        sessionState: SessionState.fromJson(json["sessionState"]),
      );

  Map<String, dynamic> toJson() => {
        "interpretations":
            List<dynamic>.from(interpretations.map((x) => x.toJson())),
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
        "sessionId": sessionId,
        "sessionState": sessionState.toJson(),
      };
}

class Interpretation {
  Interpretation({
    required this.intent,
    this.nluConfidence,
  });

  InterpretationIntent intent;
  NluConfidence? nluConfidence;

  factory Interpretation.fromJson(Map<String, dynamic> json) => Interpretation(
        intent: InterpretationIntent.fromJson(json["intent"]),
        nluConfidence: json["nluConfidence"] == null
            ? null
            : NluConfidence.fromJson(json["nluConfidence"]),
      );

  Map<String, dynamic> toJson() => {
        "intent": intent.toJson(),
        "nluConfidence": nluConfidence == null ? null : nluConfidence!.toJson(),
      };
}

class InterpretationIntent {
  InterpretationIntent({
    required this.confirmationState,
    required this.name,
    required this.slots,
    required this.state,
  });

  dynamic confirmationState;
  String name;
  PurpleSlots slots;
  String state;

  factory InterpretationIntent.fromJson(Map<String, dynamic> json) =>
      InterpretationIntent(
        confirmationState: json["confirmationState"],
        name: json["name"],
        slots: PurpleSlots.fromJson(json["slots"]),
        state: json["state"] == null ? null : json["state"],
      );

  Map<String, dynamic> toJson() => {
        "confirmationState": confirmationState,
        "name": name,
        "slots": slots.toJson(),
        "state": state == null ? null : state,
      };
}

class PurpleSlots {
  PurpleSlots({
    required this.elencoAspetti,
    required this.flowerType,
    required this.pickupDate,
    required this.pickupTime,
  });

  dynamic elencoAspetti;
  dynamic flowerType;
  dynamic pickupDate;
  dynamic pickupTime;

  factory PurpleSlots.fromJson(Map<String, dynamic> json) => PurpleSlots(
        elencoAspetti: json["ElencoAspetti"],
        flowerType: json["FlowerType"],
        pickupDate: json["PickupDate"],
        pickupTime: json["PickupTime"],
      );

  Map<String, dynamic> toJson() => {
        "ElencoAspetti": elencoAspetti,
        "FlowerType": flowerType,
        "PickupDate": pickupDate,
        "PickupTime": pickupTime,
      };
}

class NluConfidence {
  NluConfidence({
    required this.score,
  });

  double score;

  factory NluConfidence.fromJson(Map<String, dynamic> json) => NluConfidence(
        score: json["score"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "score": score,
      };
}

class Message {
  Message({
    this.content,
    this.contentType,
    this.imageResponseCard,
  });

  String? content;
  String? contentType;
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

class SessionState {
  SessionState({
    required this.dialogAction,
    required this.intent,
    required this.originatingRequestId,
    required this.sessionAttributes,
  });

  DialogAction dialogAction;
  SessionStateIntent intent;
  String originatingRequestId;
  SessionAttributes sessionAttributes;

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
        dialogAction: DialogAction.fromJson(json["dialogAction"]),
        intent: SessionStateIntent.fromJson(json["intent"]),
        originatingRequestId: json["originatingRequestId"],
        sessionAttributes:
            SessionAttributes.fromJson(json["sessionAttributes"]),
      );

  Map<String, dynamic> toJson() => {
        "dialogAction": dialogAction.toJson(),
        "intent": intent.toJson(),
        "originatingRequestId": originatingRequestId,
        "sessionAttributes": sessionAttributes.toJson(),
      };
}

class DialogAction {
  DialogAction({
    required this.slotToElicit,
    required this.type,
  });

  String slotToElicit;
  String type;

  factory DialogAction.fromJson(Map<String, dynamic> json) => DialogAction(
        slotToElicit: json["slotToElicit"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "slotToElicit": slotToElicit,
        "type": type,
      };
}

class SessionStateIntent {
  SessionStateIntent({
    required this.confirmationState,
    required this.name,
    required this.slots,
    required this.state,
  });

  dynamic confirmationState;
  String name;
  FluffySlots slots;
  String state;

  factory SessionStateIntent.fromJson(Map<String, dynamic> json) =>
      SessionStateIntent(
        confirmationState: json["confirmationState"],
        name: json["name"],
        slots: FluffySlots.fromJson(json["slots"]),
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "confirmationState": confirmationState,
        "name": name,
        "slots": slots.toJson(),
        "state": state,
      };
}

class FluffySlots {
  FluffySlots({
    required this.elencoAspetti,
  });

  dynamic elencoAspetti;

  factory FluffySlots.fromJson(Map<String, dynamic> json) => FluffySlots(
        elencoAspetti: json["ElencoAspetti"],
      );

  Map<String, dynamic> toJson() => {
        "ElencoAspetti": elencoAspetti,
      };
}

class SessionAttributes {
  SessionAttributes();

  factory SessionAttributes.fromJson(Map<String, dynamic> json) =>
      SessionAttributes();

  Map<String, dynamic> toJson() => {};
}
