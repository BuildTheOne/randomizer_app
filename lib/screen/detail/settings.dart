import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../data/datalist.dart';
import 'edit.dart';

class DetailSettingScreen extends StatefulWidget {
  const DetailSettingScreen({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<DetailSettingScreen> createState() => _DetailSettingScreenState();
}

class _DetailSettingScreenState extends State<DetailSettingScreen> {
  TextEditingController renameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DataList dataList = context.watch<DataList>();
    if (dataList.data.length != widget.index) {
      Map<String, dynamic> data = jsonDecode(dataList.data[widget.index]);

      final List<Map<String, dynamic>> settings = [
        {
          'name': 'Edit List',
          'icon': Icons.list,
          'onTap': () {
            // TODO
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailEditScreen(
                  index: (widget.index),
                ),
              ),
            );
          },
        },
        {
          'name': 'Rename List',
          'icon': Icons.create,
          'onTap': () {
            renameCtrl.text = data['name'];
            showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: const Text('Rename List'),
                  content: TextField(
                    controller: renameCtrl,
                    decoration: const InputDecoration(
                      hintText: "New List Name",
                    ),
                    autofocus: true,
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        'Rename',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      onPressed: () {
                        if (dataList.data
                                .where((element) =>
                                    (jsonDecode(element)['name'] ==
                                        renameCtrl.text))
                                .toList()
                                .isEmpty &&
                            renameCtrl.text != "") {
                          dataList.renameData(renameCtrl.text, widget.index);
                          Navigator.pop(context);
                          renameCtrl.clear();
                        } else if (renameCtrl.text == "") {
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
                    )
                  ],
                  actionsPadding: const EdgeInsets.all(8.0),
                );
              },
            );
          },
        },
        {
          'name': 'Delete List',
          'icon': Icons.delete,
          'onTap': () {
            showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text(
                        "Are you sure you want to delete this list?"),
                    actions: [
                      TextButton(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.red,
                          ),
                        ),
                        onPressed: () {
                          dataList.deleteData(widget.index);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                    actionsPadding: const EdgeInsets.all(8.0),
                  );
                });
          },
          'color': Colors.red,
          'fontWeight': FontWeight.bold,
        },
      ];

      return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(8.0),
          itemCount: settings.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: settings[index]['onTap'],
              title: Text(
                settings[index]['name'],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: settings[index]['fontWeight'],
                ),
              ),
              leading: Icon(
                settings[index]['icon'],
                size: 28.0,
              ),
              iconColor: settings[index]['color'],
              textColor: settings[index]['color'],
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      );
    }
    return const Scaffold();
  }
}
