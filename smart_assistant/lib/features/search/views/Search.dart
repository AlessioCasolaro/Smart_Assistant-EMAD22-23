import 'dart:convert';
import 'dart:developer';
import 'dart:core';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_assistant/features/chat_bot/models/responseParser.dart';
import 'package:smart_assistant/features/dashboard/classes/Response.dart';

class SearchView extends StatefulWidget {
  static List<String> docList = [];
  static List<String> urlList = [];

  SearchView({Key? key, required OggettoOggetto oggetto}) : super(key: key);
  @override
  State<SearchView> createState() => _SearchViewState();
}

Future loaddot() async {
  await dotenv.load(fileName: ".env");
}

Future<http.Response> getData(String titolo) {
  return http.post(
    Uri.parse(dotenv.env['URL_SEARCH'].toString()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'titolo': titolo,
    }),
  );
}

class DataFromResponse {
  static Future<ResponseDashboard> getDataLocally(
      BuildContext context, String titolo) async {
    final data = await getData(titolo);
    final reportData = responseFromJsonDashboard(data.body);

    log("Log Search" + data.body.toString());
    return reportData;
  }
}

class _SearchViewState extends State<SearchView> {
  String searchValue = '';
  OggettoOggetto? oggetto;

  late Attivita attivita;
  List<ContenutosOggetto> contenutoOggetto = [];
  Future<void> getAttivitas() async {
    await DataFromResponse.getDataLocally(context, searchValue).then((value) {
      setState(() {
        attivita = value.data.attivitas[0];
        oggetto = attivita.oggettoOggettos[0];
        for (int i = 0; i < oggetto!.contenutosOggetto.length; i++) {
          contenutoOggetto.add(oggetto!.contenutosOggetto[i]);
        }
      });
    });
  }

  void fillDocList() {
    for (int i = 0; i < contenutoOggetto.length; i++) {
      SearchView.docList.add(contenutoOggetto[i].titolo);
      SearchView.urlList.add(contenutoOggetto[i].riferimentoDocumentale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Example',
        theme: ThemeData(primarySwatch: Colors.orange),
        home: Scaffold(
            appBar: EasySearchBar(
              title: const Text('Example'),
              onSearch: (value) => setState(() => searchValue = value),
              actions: [
                IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      getAttivitas().whenComplete(() => fillDocList());
                    })
              ],
            ),
            drawer: Drawer(
                child: ListView(padding: EdgeInsets.zero, children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                  title: const Text('Item 1'),
                  onTap: () => Navigator.pop(context)),
              ListTile(
                  title: const Text('Item 2'),
                  onTap: () => Navigator.pop(context))
            ])),
            body: Center(child: Text('Value: $searchValue'))));
  }
}
