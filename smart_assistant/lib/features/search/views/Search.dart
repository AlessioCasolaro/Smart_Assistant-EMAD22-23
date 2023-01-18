import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:smart_assistant/features/search/classes/ResponseSearch.dart';
import 'package:smart_assistant/features/dashboard/classes/Response.dart';

import '../../../shared/res/colors.dart';
import '../../../shared/res/typography.dart';
import '../../dashboard/widgets/document.dart';
import '../../dashboard/widgets/documentsList.dart';
import '../../dashboard/widgets/machine_stats.dart';

OggettoOggetto? ogg;
String searchValueRecived = "";

class SearchView extends StatefulWidget {
  static List<String> docList = [];
  static List<String> urlList = [];

  SearchView({Key? key, required OggettoOggetto oggetto}) : super(key: key) {
    ogg = oggetto;
  }
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
  static Future<ResponseSearch> getDataLocally(
      BuildContext context, String titolo) async {
    ResponseSearch responseSearch = ResponseSearch();
    final data = await getData(titolo);
    final reportData = responseSearchFromJson(data.body);

    return reportData!;
  }
}

class _SearchViewState extends State<SearchView> {
  //String searchValue = MySearchDelegate().query;

  List<RicercaDocumentiTitolo> listaDocumenti = [];
  Future<void> getAttivitas() async {
    await DataFromResponse.getDataLocally(context, searchValueRecived)
        .then((value) {
      setState(() {
        SearchView.docList = [];
        SearchView.urlList = [];
      });
      for (int i = 0; i < value.ricercaDocumentiTitolo!.length; i++) {
        setState(() {
          SearchView.docList
              .add(value.ricercaDocumentiTitolo![i]!.titolo.toString());
          SearchView.urlList.add(value
              .ricercaDocumentiTitolo![i]!.riferimentoDocumentale
              .toString());
        });
      }
    });
  }

  void fillDocList() {
    for (int i = 0; i < listaDocumenti.length; i++) {
      SearchView.docList.add(listaDocumenti[i].titolo!);
      SearchView.urlList.add(listaDocumenti[i].riferimentoDocumentale!);
    }
  }

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search Documents"),
          backgroundColor: SmartAssistantColors.primary,
          elevation: 0,
        ),
        body: Column(
          children: [
            MachineStats(
                macchina: ogg!,
                box: const BoxDecoration(color: Color(0xFF1F75FE))),
            const SizedBox(height: 10),
            Container(
              width: 600.h,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search your document',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: Color(0xFF1F75FE))),
                ),
                controller: _controller,
                onSubmitted: (searchValue) async {
                  {
                    setState(() {
                      searchValueRecived = _controller.text;
                    });
                  }
                  await getAttivitas();
                },
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32.h),
                      //Titolo al centro
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Documents list',
                            style: TextStyles.body.copyWith(
                              fontSize: TextStyles.headline2.fontSize,
                              color: SmartAssistantColors.primary,
                            ),
                          )
                        ],
                      ),

                      DocumentsList(
                        oggetto: ogg!,
                        document: List.generate(
                          SearchView.docList.length,
                          (i) => Document(
                            'Documento ' + SearchView.docList[i],
                            SearchView.urlList[i],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ));
  }
}
