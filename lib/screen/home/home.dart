import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:convert';
import '../detail/detail.dart';
import '../../data/datalist.dart';
import '../detail/edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> search = [];
  TextEditingController newListCtrl = TextEditingController();
  TextEditingController srcListCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DataList dataList = context.watch<DataList>();
    search = dataList.data
        .where((element) =>
            ((jsonDecode(element)['name'].toString()).toLowerCase())
                .contains(srcListCtrl.text.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Randomizer"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: TextField(
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  hintText: "Search List",
                  suffixIcon: (srcListCtrl.text == "")
                      ? IconButton(
                          onPressed: () => FocusScope.of(context).nextFocus(),
                          icon: const Icon(Icons.search),
                        )
                      : IconButton(
                          onPressed: () {
                            srcListCtrl.clear();
                            setState(() {
                              search = dataList.data
                                  .where((element) =>
                                      ((jsonDecode(element)['name'].toString())
                                              .toLowerCase())
                                          .contains(
                                              srcListCtrl.text.toLowerCase()))
                                  .toList();
                            });
                          },
                          icon: const Icon(Icons.close_sharp),
                        ),
                ),
                onChanged: (keyword) {
                  setState(() {
                    search = dataList.data
                        .where((element) =>
                            ((jsonDecode(element)['name'].toString())
                                    .toLowerCase())
                                .contains(keyword.toLowerCase()))
                        .toList();
                    // print(search.length);
                  });
                  // print(search.length);
                },
                controller: srcListCtrl,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: search.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      jsonDecode(search[index])['name'],
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    trailing: InkWell(
                      child: const Icon(
                        Icons.list,
                        size: 28.0,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailEditScreen(
                              index: dataList.data.indexOf(search[index]),
                            ),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            index: dataList.data.indexOf(search[index]),
                          ),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.blue,
        spacing: 3,
        buttonSize: const Size(60.0, 60.0),
        childrenButtonSize: const Size(56.0, 56.0),
        elevation: 10.0,
        children: [
          SpeedDialChild(
            label: 'Import from txt',
            child: const Icon(
              Icons.text_snippet,
              size: 20.0,
            ),
            onTap: () {
              // TODO
            },
          ),
          SpeedDialChild(
            label: 'Create new list',
            child: const Icon(
              Icons.list,
              size: 20.0,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Create New List'),
                    content: TextField(
                      controller: newListCtrl,
                      decoration:
                          const InputDecoration(hintText: "New List Name"),
                      autofocus: true,
                    ),
                    actions: [
                      TextButton(
                        child: const Text(
                          'Create',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () async {
                          if (dataList.data
                                  .where((element) =>
                                      (jsonDecode(element)['name'] ==
                                          newListCtrl.text))
                                  .toList()
                                  .isEmpty &&
                              newListCtrl.text != "") {
                            dataList.addData({
                              'name': newListCtrl.text,
                              'data': [],
                              'chosen': [],
                              'notChosen': [],
                              'number': 1,
                            });
                            Navigator.pop(context);
                            newListCtrl.clear();
                          } else if (newListCtrl.text == "") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Name cannot be blank"),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Name already exists"),
                            ));
                          }
                        },
                      ),
                    ],
                    actionsPadding: const EdgeInsets.all(8.0),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
