// To parse this JSON data, do
//
//     final responseSearch = responseSearchFromJson(jsonString);

import 'dart:convert';

ResponseSearch? responseSearchFromJson(String str) =>
    ResponseSearch.fromJson(json.decode(str));

String responseSearchToJson(ResponseSearch? data) =>
    json.encode(data!.toJson());

class ResponseSearch {
  ResponseSearch({
    this.ricercaDocumentiTitolo,
  });

  List<RicercaDocumentiTitolo?>? ricercaDocumentiTitolo;

  factory ResponseSearch.fromJson(Map<String, dynamic> json) => ResponseSearch(
        ricercaDocumentiTitolo: json["ricercaDocumentiTitolo"] == null
            ? []
            : List<RicercaDocumentiTitolo?>.from(json["ricercaDocumentiTitolo"]!
                .map((x) => RicercaDocumentiTitolo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ricercaDocumentiTitolo": ricercaDocumentiTitolo == null
            ? []
            : List<dynamic>.from(
                ricercaDocumentiTitolo!.map((x) => x!.toJson())),
      };
}

class RicercaDocumentiTitolo {
  RicercaDocumentiTitolo({
    this.titolo,
    this.riferimentoDocumentale,
  });

  String? titolo;
  String? riferimentoDocumentale;

  factory RicercaDocumentiTitolo.fromJson(Map<String, dynamic> json) =>
      RicercaDocumentiTitolo(
        titolo: json["titolo"],
        riferimentoDocumentale: json["riferimentoDocumentale"],
      );

  Map<String, dynamic> toJson() => {
        "titolo": titolo,
        "riferimentoDocumentale": riferimentoDocumentale,
      };
}
