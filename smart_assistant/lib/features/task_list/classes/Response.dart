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
    required this.istanzaAttivitas,
  });

  List<IstanzaAttivita> istanzaAttivitas;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        istanzaAttivitas: List<IstanzaAttivita>.from(
            json["istanzaAttivitas"].map((x) => IstanzaAttivita.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "istanzaAttivitas":
            List<dynamic>.from(istanzaAttivitas.map((x) => x.toJson())),
      };
}

class IstanzaAttivita {
  IstanzaAttivita({
    required this.codiceIstanzaAttivita,
    required this.dataAvvio,
    required this.attivitaAttivitas,
  });

  String codiceIstanzaAttivita;
  DateTime dataAvvio;
  AttivitaAttivitas attivitaAttivitas;

  factory IstanzaAttivita.fromJson(Map<String, dynamic> json) =>
      IstanzaAttivita(
        codiceIstanzaAttivita: json["codiceIstanzaAttivita"],
        dataAvvio: DateTime.parse(json["dataAvvio"]),
        attivitaAttivitas:
            AttivitaAttivitas.fromJson(json["attivitaAttivitas"]),
      );

  Map<String, dynamic> toJson() => {
        "codiceIstanzaAttivita": codiceIstanzaAttivita,
        "dataAvvio":
            "${dataAvvio.year.toString().padLeft(4, '0')}-${dataAvvio.month.toString().padLeft(2, '0')}-${dataAvvio.day.toString().padLeft(2, '0')}",
        "attivitaAttivitas": attivitaAttivitas.toJson(),
      };
}

class AttivitaAttivitas {
  AttivitaAttivitas({
    required this.codiceAttivita,
    required this.nome,
    required this.descrizione,
    required this.durataPrevista,
    required this.priorita,
    required this.processoProcessos,
    required this.oggettoOggettos,
    required this.attivitaRicambiTipoRicambios,
    required this.attivitaTipoAttrezzaturaTipoAttrezzaturas,
    required this.attivitaProfiloProfilos,
  });

  String codiceAttivita;
  String nome;
  String descrizione;
  int durataPrevista;
  String priorita;
  List<ProcessoProcesso> processoProcessos;
  List<OggettoOggetto> oggettoOggettos;
  List<AttivitaRicambiTipoRicambio> attivitaRicambiTipoRicambios;
  List<AttivitaTipoAttrezzaturaTipoAttrezzatura>
      attivitaTipoAttrezzaturaTipoAttrezzaturas;
  List<AttivitaProfiloProfilo> attivitaProfiloProfilos;

  factory AttivitaAttivitas.fromJson(Map<String, dynamic> json) =>
      AttivitaAttivitas(
        codiceAttivita: json["codiceAttivita"],
        nome: json["nome"],
        descrizione: json["descrizione"],
        durataPrevista: json["durataPrevista"],
        priorita: json["priorita"],
        processoProcessos: List<ProcessoProcesso>.from(
            json["processoProcessos"].map((x) => ProcessoProcesso.fromJson(x))),
        oggettoOggettos: List<OggettoOggetto>.from(
            json["oggettoOggettos"].map((x) => OggettoOggetto.fromJson(x))),
        attivitaRicambiTipoRicambios: List<AttivitaRicambiTipoRicambio>.from(
            json["attivitaRicambiTipoRicambios"]
                .map((x) => AttivitaRicambiTipoRicambio.fromJson(x))),
        attivitaTipoAttrezzaturaTipoAttrezzaturas:
            List<AttivitaTipoAttrezzaturaTipoAttrezzatura>.from(
                json["attivitaTipoAttrezzaturaTipoAttrezzaturas"].map((x) =>
                    AttivitaTipoAttrezzaturaTipoAttrezzatura.fromJson(x))),
        attivitaProfiloProfilos: List<AttivitaProfiloProfilo>.from(
            json["attivitaProfiloProfilos"]
                .map((x) => AttivitaProfiloProfilo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "codiceAttivita": codiceAttivita,
        "nome": nome,
        "descrizione": descrizione,
        "durataPrevista": durataPrevista,
        "priorita": priorita,
        "processoProcessos":
            List<dynamic>.from(processoProcessos.map((x) => x.toJson())),
        "oggettoOggettos":
            List<dynamic>.from(oggettoOggettos.map((x) => x.toJson())),
        "attivitaRicambiTipoRicambios": List<dynamic>.from(
            attivitaRicambiTipoRicambios.map((x) => x.toJson())),
        "attivitaTipoAttrezzaturaTipoAttrezzaturas": List<dynamic>.from(
            attivitaTipoAttrezzaturaTipoAttrezzaturas.map((x) => x.toJson())),
        "attivitaProfiloProfilos":
            List<dynamic>.from(attivitaProfiloProfilos.map((x) => x.toJson())),
      };
}

class AttivitaProfiloProfilo {
  AttivitaProfiloProfilo({
    required this.nome,
  });

  String nome;

  factory AttivitaProfiloProfilo.fromJson(Map<String, dynamic> json) =>
      AttivitaProfiloProfilo(
        nome: json["nome"],
      );

  Map<String, dynamic> toJson() => {
        "nome": nome,
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
    this.descrizione,
  });

  String codiceTipoAttrezzatura;
  String nome;
  dynamic descrizione;

  factory AttivitaTipoAttrezzaturaTipoAttrezzatura.fromJson(
          Map<String, dynamic> json) =>
      AttivitaTipoAttrezzaturaTipoAttrezzatura(
        codiceTipoAttrezzatura: json["codiceTipoAttrezzatura"],
        nome: json["nome"],
        descrizione: json["descrizione"],
      );

  Map<String, dynamic> toJson() => {
        "codiceTipoAttrezzatura": codiceTipoAttrezzatura,
        "nome": nome,
        "descrizione": descrizione,
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
  String descrizione;

  factory OggettoOggetto.fromJson(Map<String, dynamic> json) => OggettoOggetto(
        codiceOggetto: json["codiceOggetto"],
        nome: json["nome"],
        descrizione: json["descrizione"] == null ? 'null' : json["descrizione"],
      );

  Map<String, dynamic> toJson() => {
        "codiceOggetto": codiceOggetto,
        "nome": nome,
        "descrizione": descrizione == null ? 'null' : descrizione,
      };
}

class ProcessoProcesso {
  ProcessoProcesso({
    required this.codiceProcesso,
    required this.nome,
  });

  String codiceProcesso;
  String nome;

  factory ProcessoProcesso.fromJson(Map<String, dynamic> json) =>
      ProcessoProcesso(
        codiceProcesso: json["codiceProcesso"],
        nome: json["nome"],
      );

  Map<String, dynamic> toJson() => {
        "codiceProcesso": codiceProcesso,
        "nome": nome,
      };
}
