// To parse this JSON data, do
//
//     final response = responseFromJson(jsonString);

import 'dart:convert';

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

String responseToJson(Response data) => json.encode(data.toJson());

class Response {
  Response({
    required this.data,
  });

  Data data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
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
    required this.codiceAttivita,
    required this.descrizione,
    required this.durataPrevista,
    required this.priorita,
    required this.nome,
    required this.processoProcessos,
    required this.oggettoOggettos,
    required this.attivitaRicambiTipoRicambios,
    required this.attivitaTipoAttrezzaturaTipoAttrezzaturas,
    required this.attivitaUtenteProfiloAssegnato,
  });

  String codiceAttivita;
  String descrizione;
  int durataPrevista;
  String priorita;
  String nome;
  List<AttivitaUtenteProfiloAssegnato> processoProcessos;
  List<OggettoOggetto> oggettoOggettos;
  List<AttivitaRicambiTipoRicambio> attivitaRicambiTipoRicambios;
  List<AttivitaTipoAttrezzaturaTipoAttrezzatura>
      attivitaTipoAttrezzaturaTipoAttrezzaturas;
  AttivitaUtenteProfiloAssegnato attivitaUtenteProfiloAssegnato;

  factory Attivita.fromJson(Map<String, dynamic> json) => Attivita(
        codiceAttivita: json["codiceAttivita"],
        descrizione: json["descrizione"],
        durataPrevista: json["durataPrevista"],
        priorita: json["priorita"],
        nome: json["nome"],
        processoProcessos: List<AttivitaUtenteProfiloAssegnato>.from(
            json["processoProcessos"]
                .map((x) => AttivitaUtenteProfiloAssegnato.fromJson(x))),
        oggettoOggettos: List<OggettoOggetto>.from(
            json["oggettoOggettos"].map((x) => OggettoOggetto.fromJson(x))),
        attivitaRicambiTipoRicambios: List<AttivitaRicambiTipoRicambio>.from(
            json["attivitaRicambiTipoRicambios"]
                .map((x) => AttivitaRicambiTipoRicambio.fromJson(x))),
        attivitaTipoAttrezzaturaTipoAttrezzaturas:
            List<AttivitaTipoAttrezzaturaTipoAttrezzatura>.from(
                json["attivitaTipoAttrezzaturaTipoAttrezzaturas"].map((x) =>
                    AttivitaTipoAttrezzaturaTipoAttrezzatura.fromJson(x))),
        attivitaUtenteProfiloAssegnato: AttivitaUtenteProfiloAssegnato.fromJson(
            json["attivitaUtenteProfiloAssegnato"]),
      );

  Map<String, dynamic> toJson() => {
        "codiceAttivita": codiceAttivita,
        "descrizione": descrizione,
        "durataPrevista": durataPrevista,
        "priorita": priorita,
        "nome": nome,
        "processoProcessos":
            List<dynamic>.from(processoProcessos.map((x) => x.toJson())),
        "oggettoOggettos":
            List<dynamic>.from(oggettoOggettos.map((x) => x.toJson())),
        "attivitaRicambiTipoRicambios": List<dynamic>.from(
            attivitaRicambiTipoRicambios.map((x) => x.toJson())),
        "attivitaTipoAttrezzaturaTipoAttrezzaturas": List<dynamic>.from(
            attivitaTipoAttrezzaturaTipoAttrezzaturas.map((x) => x.toJson())),
        "attivitaUtenteProfiloAssegnato":
            attivitaUtenteProfiloAssegnato.toJson(),
      };
}

class AttivitaRicambiTipoRicambio {
  AttivitaRicambiTipoRicambio({
    required this.codiceTipoRicambio,
    required this.nome,
    required this.descrizione,
  });

  String codiceTipoRicambio;
  String nome;
  String descrizione;

  factory AttivitaRicambiTipoRicambio.fromJson(Map<String, dynamic> json) =>
      AttivitaRicambiTipoRicambio(
        codiceTipoRicambio: json["codiceTipoRicambio"],
        nome: json["nome"],
        descrizione: json["descrizione"] == null ? 'null' : json["descrizione"],
      );

  Map<String, dynamic> toJson() => {
        "codiceTipoRicambio": codiceTipoRicambio,
        "nome": nome,
        "descrizione": descrizione == null ? 'null' : descrizione,
      };
}

class AttivitaTipoAttrezzaturaTipoAttrezzatura {
  AttivitaTipoAttrezzaturaTipoAttrezzatura({
    required this.codiceTipoAttrezzatura,
    required this.nome,
    required this.descrizione,
  });

  String codiceTipoAttrezzatura;
  String nome;
  String descrizione;

  factory AttivitaTipoAttrezzaturaTipoAttrezzatura.fromJson(
          Map<String, dynamic> json) =>
      AttivitaTipoAttrezzaturaTipoAttrezzatura(
        codiceTipoAttrezzatura: json["codiceTipoAttrezzatura"],
        nome: json["nome"],
        descrizione: json["descrizione"] == null ? 'null' : json["descrizione"],
      );

  Map<String, dynamic> toJson() => {
        "codiceTipoAttrezzatura": codiceTipoAttrezzatura,
        "nome": nome,
        "descrizione": descrizione == null ? 'null' : descrizione,
      };
}

class AttivitaUtenteProfiloAssegnato {
  AttivitaUtenteProfiloAssegnato({
    required this.nome,
  });

  String nome;

  factory AttivitaUtenteProfiloAssegnato.fromJson(Map<String, dynamic> json) =>
      AttivitaUtenteProfiloAssegnato(
        nome: json["nome"],
      );

  Map<String, dynamic> toJson() => {
        "nome": nome,
      };
}

class OggettoOggetto {
  OggettoOggetto({
    required this.codiceOggetto,
    required this.nome,
    required this.descrizione,
  });

  String codiceOggetto;
  String nome;
  dynamic descrizione;

  factory OggettoOggetto.fromJson(Map<String, dynamic> json) => OggettoOggetto(
        codiceOggetto: json["codiceOggetto"],
        nome: json["nome"],
        descrizione: json["descrizione"],
      );

  Map<String, dynamic> toJson() => {
        "codiceOggetto": codiceOggetto,
        "nome": nome,
        "descrizione": descrizione,
      };
}
