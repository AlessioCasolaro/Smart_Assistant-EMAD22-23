import 'dart:convert';
import 'dart:developer';
import 'dart:core';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:smart_assistant/features/chat_bot/models/responseParser.dart';
import 'package:smart_assistant/features/dashboard/classes/Response.dart';

import '../../../shared/res/colors.dart';
import '../../../shared/res/typography.dart';
import '../../dashboard/widgets/document.dart';
import '../../dashboard/widgets/documentsList.dart';
import '../../dashboard/widgets/machine_info.dart';
import '../../dashboard/widgets/machine_stats.dart';

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
  String searchValue = MySearchDelegate().query;
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

/*
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

              DocumentsList(
                oggetto: oggetto!,
                document: List.generate(
                  SearchView.docList.length,
                  (i) => Document(
                    'Documento ' + SearchView.docList[i],
                    SearchView.urlList[i],
                  ),
                ),
              ),

            ])),
            body: Center(child: Text('Value: $searchValue'))));
  } // Build
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MySearchDelegate());
              getAttivitas().whenComplete(() => fillDocList());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 32.h),
            //Titolo al centro
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Documents',
                  style: TextStyles.body.copyWith(
                    fontSize: TextStyles.headline2.fontSize,
                    color: SmartAssistantColors.primary,
                  ),
                )
              ],
            ),
/*   Questo è commentato perchè manca la lista di documenti e da errore
            DocumentsList(
              oggetto: oggetto!,
              document: List.generate(
                SearchView.docList.length,
                (i) => Document(
                  'Documento ' + SearchView.docList[i],
                  SearchView.urlList[i],
                ),
              ),
            ),*/
          ]),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
