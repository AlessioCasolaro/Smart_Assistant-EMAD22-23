import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../shared/res/colors.dart';

int count = 0;

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notification"),
          backgroundColor: SmartAssistantColors.primary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            iconSize: 30.0,
            onPressed: () {
              Navigator.pop(context);
              count = 0;
            },
          ),
        ),
        body: const MyStatefulWidget());
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

//Create a method that returns a Future List of Item calling readData() method
Future<List<Item>> generateItems(int numberOfItems) async {
  List<Item> list = [];
  String check;
  for (int i = 0; i < numberOfItems; i++) {
    check = await readData(i, "titolo");
    if (check != "null") {
      list.add(Item(
        headerValue: await readData(i, "titolo"),
        expandedValue: await readData(i, "corpo"),
      ));
    }
  }
  return list;
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<Item> _data = <Item>[];

  void _getItems() async {
    _data = await generateItems(10);
    setState(() {});
    log(_data.toString());
  }

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      _getItems();
      count++;
    }
    return _buildPanel();
  }

  Widget _buildPanel() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView(
        children: _data.map((Item item) {
          return Container(
              margin: const EdgeInsets.all(10),
              child: Card(
                color: SmartAssistantColors.secondary,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: SmartAssistantColors.secondary,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 6.0, right: 6.0, bottom: 20.0),
                  child: ExpansionTile(
                    title: Text(item.headerValue.toString(),
                        style: const TextStyle(
                          fontSize: 30.0,
                          color: Colors.black,
                        )),
                    children: <Widget>[
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 20.0, right: 20.0, bottom: 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(item.expandedValue,
                              style: const TextStyle(
                                fontSize: 24.0,
                                color: Colors.black,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: GestureDetector(
                          onTap: () async {
                            await removeData(_data.indexOf(item), "titolo",
                                "corpo"); //remove data from firebase
                            setState(() {
                              _data.remove(item);
                            });
                          },
                          child: const Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.delete,
                                size: 30,
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        }).toList(),
      ),
    );
  }
}

Future<String> readData(int count, String campo) async {
  DatabaseReference reference =
      // FirebaseDatabase.instance.ref().child("users").child(user).child("name");
      FirebaseDatabase.instance
          .ref()
          .child("notifiche")
          .child(count.toString())
          .child(campo);
  DatabaseEvent event = await reference.once();
  log(event.snapshot.value.toString());
  return event.snapshot.value.toString();
}

Future<void> removeData(int count, String campo, String campo2) async {
  try {
    FirebaseDatabase.instance
        .ref()
        .child("notifiche")
        .child(count.toString())
        .child(campo)
        .remove();

    FirebaseDatabase.instance
        .ref()
        .child("notifiche")
        .child(count.toString())
        .child(campo2)
        .remove();
  } catch (e) {
    log(e.toString());
  }
  log("removed");
}
