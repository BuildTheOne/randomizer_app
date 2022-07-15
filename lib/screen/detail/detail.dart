import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../data/datalist.dart';
import 'edit.dart';
import 'settings.dart';
import 'dart:math';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<String> dataItems = [];
  List<String> chosenItems = [];
  TextEditingController? numCtrl;

  @override
  Widget build(BuildContext context) {
    DataList dataList = context.watch<DataList>();

    if (dataList.data.length != widget.index) {
      Map<String, dynamic> data = jsonDecode(dataList.data[widget.index]);
      dataItems = List<String>.from(data['notChosen']);
      chosenItems = List<String>.from(data['chosen']);
      numCtrl = TextEditingController(text: data['number'].toString());

      List<Map<String, dynamic>> popup = [
        {
          "title": "History",
          'value': "history",
        },
        {
          "title": "Edit List",
          'value': "edit",
        },
        {
          "title": "Settings",
          'value': "settings",
        },
      ];

      choiceAction(Object? choice) {
        if (choice == "history") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: const Text('History'),
                children: chosenItems.map(
                  (element) {
                    return SimpleDialogOption(
                      child: Text(
                        element,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      onPressed: () {},
                    );
                  },
                ).toList(),
              );
            },
          );
        } else if (choice == "edit") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailEditScreen(
                index: (widget.index),
              ),
            ),
          );
        } else if (choice == "settings") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailSettingScreen(
                index: (widget.index),
              ),
            ),
          );
        }
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(data['name']),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Settings'),
                      content: TextField(
                        controller: numCtrl,
                        decoration: const InputDecoration(
                          hintText: "# Number to choose",
                          helperText: "# Number to choose",
                        ),
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close"),
                        ),
                        TextButton(
                          onPressed: () {
                            if (numCtrl?.text != "") {
                              dataList.settingSave(widget.index, numCtrl!.text);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.settings),
              splashRadius: 16,
            ),
            IconButton(
              onPressed: () {
                dataList.refreshChosen(widget.index);
                ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("List Refreshed!"),
                          ));
              },
              icon: const Icon(Icons.refresh),
              splashRadius: 16,
            ),
            PopupMenuButton(
              onSelected: (choice) => choiceAction(choice),
              itemBuilder: (BuildContext context) {
                return popup.map(
                  (item) {
                    return PopupMenuItem(
                      value: item['value'],
                      child: Text(item['title']),
                    );
                  },
                ).toList();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              child: Text(
                (dataItems.length).toString() +
                    (dataItems.length != 1 ? " items" : " item"),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 8, right: 8),
                shrinkWrap: true,
                itemCount: dataItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      dataItems[index],
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    trailing: InkWell(
                      child: const Icon(Icons.close_sharp),
                      onTap: () {
                        dataList.removeChosen(widget.index, dataItems[index]);
                      },
                    ),
                    onTap: () {},
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  child: const Text(
                    "Choose",
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () {
                    // TODO
                    List<String> chosenData = [];
                    if (dataItems.isNotEmpty) {
                      for (int i = 0; i < data['number']; i++) {
                        if (dataItems.isNotEmpty) {
                          String chosen = dataItems.removeAt(Random().nextInt(
                            dataItems.length,
                          ));
                          // print(dataItems);
                          chosenData.add(chosen);
                          dataList.chooseItem(widget.index, chosen);
                        } else {
                          break;
                        }
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: const Text('And the chosen one is...'),
                            children: chosenData.map(
                              (element) {
                                return SimpleDialogOption(
                                  child: Text(
                                    element,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  onPressed: () {},
                                );
                              },
                            ).toList(),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const Scaffold();
  }
}
