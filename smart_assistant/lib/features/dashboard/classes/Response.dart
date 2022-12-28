// To parse this JSON data, do
//
//     final response = responseFromJsonDashboard(jsonString);

import 'dart:convert';

ResponseDashboard responseFromJsonDashboard(String str) =>
    ResponseDashboard.fromJson(json.decode(str));

String responseToJson(ResponseDashboard data) => json.encode(data.toJson());

class ResponseDashboard {
  ResponseDashboard({
    required this.data,
  });

  Data data;

  factory ResponseDashboard.fromJson(Map<String, dynamic> json) =>
      ResponseDashboard(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.attivitas,
  });

  List<Attivita> attivitas;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        attivitas: List<Attivita>.from(
            json["attivitas"].map((x) => Attivita.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "attivitas": List<dynamic>.from(attivitas.map((x) => x.toJson())),
      };
}

class Attivita {
  Attivita({
    required this.oggettoOggettos,
  });

  List<OggettoOggetto> oggettoOggettos;

  factory Attivita.fromJson(Map<String, dynamic> json) => Attivita(
        oggettoOggettos: List<OggettoOggetto>.from(
            json["oggettoOggettos"].map((x) => OggettoOggetto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "oggettoOggettos":
            List<dynamic>.from(oggettoOggettos.map((x) => x.toJson())),
      };
}

class OggettoOggetto {
  OggettoOggetto({
    required this.nome,
    required this.descrizione,
    required this.tipoOggettoTipoOggettos,
    required this.urlImmagine,
    required this.contenutosOggetto,
    required this.sensoresOggetto,
  });

  String nome;
  String descrizione;
  TipoOggettoTipoOggettos tipoOggettoTipoOggettos;
  String urlImmagine;
  List<ContenutosOggetto> contenutosOggetto;
  List<SensoresOggetto> sensoresOggetto;

  factory OggettoOggetto.fromJson(Map<String, dynamic> json) => OggettoOggetto(
        nome: json["nome"],
        descrizione: json["descrizione"],
        tipoOggettoTipoOggettos:
            TipoOggettoTipoOggettos.fromJson(json["tipoOggettoTipoOggettos"]),
        urlImmagine: json["urlImmagine"],
        contenutosOggetto: List<ContenutosOggetto>.from(
            json["contenutosOggetto"]
                .map((x) => ContenutosOggetto.fromJson(x))),
        sensoresOggetto: List<SensoresOggetto>.from(
            json["sensoresOggetto"].map((x) => SensoresOggetto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "nome": nome,
        "descrizione": descrizione,
        "tipoOggettoTipoOggettos": tipoOggettoTipoOggettos.toJson(),
        "urlImmagine": urlImmagine,
        "contenutosOggetto":
            List<dynamic>.from(contenutosOggetto.map((x) => x.toJson())),
        "sensoresOggetto":
            List<dynamic>.from(sensoresOggetto.map((x) => x.toJson())),
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

class SensoresOggetto {
  SensoresOggetto({
    required this.nome,
    required this.descrizione,
    required this.unitaMisura,
  });

  String nome;
  String descrizione;
  String unitaMisura;

  factory SensoresOggetto.fromJson(Map<String, dynamic> json) =>
      SensoresOggetto(
        nome: json["nome"],
        descrizione: json["descrizione"],
        unitaMisura: json["unitaMisura"],
      );

  Map<String, dynamic> toJson() => {
        "nome": nome,
        "descrizione": descrizione,
        "unitaMisura": unitaMisura,
      };
}

class TipoOggettoTipoOggettos {
  TipoOggettoTipoOggettos({
    required this.nome,
  });

  String nome;

  factory TipoOggettoTipoOggettos.fromJson(Map<String, dynamic> json) =>
      TipoOggettoTipoOggettos(
        nome: json["nome"],
      );

  Map<String, dynamic> toJson() => {
        "nome": nome,
      };
}
