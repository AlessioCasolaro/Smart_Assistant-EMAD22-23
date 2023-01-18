// To parse this JSON data, do
//
//     final response = responseFromJson(jsonString);

import 'dart:convert';

Response? responseFromJson(String str) => Response.fromJson(json.decode(str));

String responseToJson(Response? data) => json.encode(data!.toJson());

class Response {
  Response({
    this.interpretations,
    this.messages,
    this.requestAttributes,
    this.sessionId,
    this.sessionState,
  });

  List<Interpretation?>? interpretations;
  List<Message?>? messages;
  RequestAttributes? requestAttributes;
  String? sessionId;
  SessionState? sessionState;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        interpretations: json["interpretations"] == null
            ? []
            : List<Interpretation?>.from(json["interpretations"]!
                .map((x) => Interpretation.fromJson(x))),
        messages: json["messages"] == null
            ? []
            : List<Message?>.from(
                json["messages"]!.map((x) => Message.fromJson(x))),
        requestAttributes:
            RequestAttributes.fromJson(json["requestAttributes"]),
        sessionId: json["sessionId"],
        sessionState: SessionState.fromJson(json["sessionState"]),
      );

  Map<String, dynamic> toJson() => {
        "interpretations": interpretations == null
            ? []
            : List<dynamic>.from(interpretations!.map((x) => x!.toJson())),
        "messages": messages == null
            ? []
            : List<dynamic>.from(messages!.map((x) => x!.toJson())),
        "requestAttributes": requestAttributes!.toJson(),
        "sessionId": sessionId,
        "sessionState": sessionState!.toJson(),
      };
}

class Interpretation {
  Interpretation({
    this.intent,
    this.nluConfidence,
  });

  InterpretationIntent? intent;
  NluConfidence? nluConfidence;

  factory Interpretation.fromJson(Map<String, dynamic> json) => Interpretation(
        intent: InterpretationIntent.fromJson(json["intent"]),
        nluConfidence: null,
      );

  Map<String, dynamic> toJson() => {
        "intent": intent!.toJson(),
        "nluConfidence": nluConfidence,
      };
}

class InterpretationIntent {
  InterpretationIntent({
    this.confirmationState,
    this.name,
    this.slots,
    this.state,
  });

  String? confirmationState;
  String? name;
  Slots? slots;
  String? state;

  factory InterpretationIntent.fromJson(Map<String, dynamic> json) =>
      InterpretationIntent(
        confirmationState: json["confirmationState"],
        name: json["name"],
        slots: Slots.fromJson(json["slots"]),
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "confirmationState": confirmationState,
        "name": name,
        "slots": slots!.toJson(),
        "state": state,
      };
}

class Slots {
  Slots({
    this.flowerType,
    this.pickupDate,
    this.pickupTime,
  });

  dynamic flowerType;
  dynamic pickupDate;
  dynamic pickupTime;

  factory Slots.fromJson(Map<String, dynamic> json) => Slots(
        flowerType: json["FlowerType"],
        pickupDate: json["PickupDate"],
        pickupTime: json["PickupTime"],
      );

  Map<String, dynamic> toJson() => {
        "FlowerType": flowerType,
        "PickupDate": pickupDate,
        "PickupTime": pickupTime,
      };
}

class NluConfidence {
  NluConfidence({
    this.score,
  });

  double? score;

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
  });

  List<Content?>? content;
  String? contentType;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        content: json["content"] == null
            ? []
            : List<Content?>.from(
                json["content"]!.map((x) => Content.fromJson(x))),
        contentType: json["contentType"],
      );

  Map<String, dynamic> toJson() => {
        "content": content == null
            ? []
            : List<dynamic>.from(content!.map((x) => x!.toJson())),
        "contentType": contentType,
      };
}

class Content {
  Content({
    this.stringa,
    this.titolo,
    this.riferimentoDocumentale,
    this.codiceTopic,
    this.nome,
  });

  String? stringa;
  String? titolo;
  String? riferimentoDocumentale;
  String? codiceTopic;
  String? nome;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        stringa: json["stringa"],
        titolo: json["titolo"],
        riferimentoDocumentale: json["riferimentoDocumentale"],
        codiceTopic: json["codiceTopic"],
        nome: json["nome"],
      );

  Map<String, dynamic> toJson() => {
        "stringa": stringa,
        "titolo": titolo,
        "riferimentoDocumentale": riferimentoDocumentale,
        "codiceTopic": codiceTopic,
        "nome": nome,
      };
}

class RequestAttributes {
  RequestAttributes({
    this.codiceAttivita,
    this.codiceProcesso,
  });

  String? codiceAttivita;
  String? codiceProcesso;

  factory RequestAttributes.fromJson(Map<String, dynamic> json) =>
      RequestAttributes(
        codiceAttivita: json["codiceAttivita"],
        codiceProcesso: json["codiceProcesso"],
      );

  Map<String, dynamic> toJson() => {
        "codiceAttivita": codiceAttivita,
        "codiceProcesso": codiceProcesso,
      };
}

class SessionState {
  SessionState({
    this.dialogAction,
    this.intent,
    this.originatingRequestId,
    this.sessionAttributes,
  });

  DialogAction? dialogAction;
  SessionStateIntent? intent;
  String? originatingRequestId;
  SessionAttributes? sessionAttributes;

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
        dialogAction: DialogAction.fromJson(json["dialogAction"]),
        intent: SessionStateIntent.fromJson(json["intent"]),
        originatingRequestId: json["originatingRequestId"],
        sessionAttributes:
            SessionAttributes.fromJson(json["sessionAttributes"]),
      );

  Map<String, dynamic> toJson() => {
        "dialogAction": dialogAction!.toJson(),
        "intent": intent!.toJson(),
        "originatingRequestId": originatingRequestId,
        "sessionAttributes": sessionAttributes!.toJson(),
      };
}

class DialogAction {
  DialogAction({
    this.type,
  });

  String? type;

  factory DialogAction.fromJson(Map<String, dynamic> json) => DialogAction(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}

class SessionStateIntent {
  SessionStateIntent({
    this.confirmationState,
    this.name,
    this.slots,
    this.state,
  });

  String? confirmationState;
  String? name;
  SessionAttributes? slots;
  String? state;

  factory SessionStateIntent.fromJson(Map<String, dynamic> json) =>
      SessionStateIntent(
        confirmationState: json["confirmationState"],
        name: json["name"],
        slots: SessionAttributes.fromJson(json["slots"]),
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "confirmationState": confirmationState,
        "name": name,
        "slots": slots!.toJson(),
        "state": state,
      };
}

class SessionAttributes {
  SessionAttributes();

  factory SessionAttributes.fromJson(Map<String, dynamic> json) =>
      SessionAttributes();

  Map<String, dynamic> toJson() => {};
}
