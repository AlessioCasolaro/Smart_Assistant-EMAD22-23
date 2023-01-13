// To parse this JSON data, do
//
//     final responseSearch = responseSearchFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ResponseSearch responseSearchFromJson(String str) =>
    ResponseSearch.fromJson(json.decode(str));

String responseSearchToJson(ResponseSearch data) => json.encode(data.toJson());

class ResponseSearch {
  ResponseSearch({
    required this.data,
  });

  Data data;

  factory ResponseSearch.fromJson(Map<String, dynamic> json) => ResponseSearch(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.contenutosOggetto,
  });

  List<ContenutosOggetto> contenutosOggetto;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        contenutosOggetto: List<ContenutosOggetto>.from(
            json["contenutosOggetto"]
                .map((x) => ContenutosOggetto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "contenutosOggetto":
            List<dynamic>.from(contenutosOggetto.map((x) => x.toJson())),
      };
}

class ContenutosOggetto {
  ContenutosOggetto({
    required this.titolo,
    required this.riferimentoDocumentale,
  });

  String titolo;
  String riferimentoDocumentale;

  factory ContenutosOggetto.fromJson(Map<String, dynamic> json) =>
      ContenutosOggetto(
        titolo: json["titolo"],
        riferimentoDocumentale: json["riferimentoDocumentale"],
      );

  Map<String, dynamic> toJson() => {
        "titolo": titolo,
        "riferimentoDocumentale": riferimentoDocumentale,
      };
}
