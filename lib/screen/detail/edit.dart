import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../data/datalist.dart';

class DetailEditScreen extends StatefulWidget {
  const DetailEditScreen({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<DetailEditScreen> createState() => _DetailEditScreenState();
}

class _DetailEditScreenState extends State<DetailEditScreen> {
  List<String> search = [];
  TextEditingController newItemCtrl = TextEditingController();
  TextEditingController srcListCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DataList dataList = context.watch<DataList>();
    Map<String, dynamic> data = jsonDecode(dataList.data[widget.index]);
    List<String> dataItems = List<String>.from(data['data']);
    search = dataItems
        .where((element) => element.contains(srcListCtrl.text))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit List"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
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
                                  onPressed: () {},
                                  icon: const Icon(Icons.search),
                                )
                              : IconButton(
                                  onPressed: () {
                                    srcListCtrl.clear();
                                    setState(() {
                                      search = dataItems
                                          .where((element) => element
                                              .contains(srcListCtrl.text))
                                          .toList();
                                    });
                                  },
                                  icon: const Icon(Icons.close_sharp),
                                ),
                        ),
                        onChanged: (keyword) {
                          setState(() {
                            search = dataItems
                                .where((element) =>
                                    element.contains(srcListCtrl.text))
                                .toList();
                          });
                        },
                        controller: srcListCtrl,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Create New Item'),
                              content: TextField(
                                controller: newItemCtrl,
                                decoration: const InputDecoration(
                                    hintText: "New List Name"),
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
                                  onPressed: () {
                                    if (!dataItems.contains(newItemCtrl.text) &&
                                        newItemCtrl.text != "") {
                                      dataList.addDataItem(
                                          widget.index, newItemCtrl.text);
                                      Navigator.pop(context);
                                      newItemCtrl.clear();
                                    } else if (newItemCtrl.text == "") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("Name cannot be blank"),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("Name already exists"),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                              actionsPadding: const EdgeInsets.all(8.0),
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        size: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
            // Container(
            //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       border: Border.all(color: Colors.white),
            //     ),
            //     child: Row(
            //       children: [
            //         TextField(
            //           style: const TextStyle(
            //             fontSize: 20.0,
            //           ),
            //           decoration: InputDecoration(
            //             hintText: "Search List",
            //             suffixIcon: (srcListCtrl.text == "")
            //                 ? IconButton(
            //                     onPressed: () {},
            //                     icon: const Icon(Icons.search),
            //                   )
            //                 : IconButton(
            //                     onPressed: () {
            //                       srcListCtrl.clear();
            //                       setState(() {
            //                         search = dataItems
            //                             .where((element) =>
            //                                 element.contains(srcListCtrl.text))
            //                             .toList();
            //                       });
            //                     },
            //                     icon: const Icon(Icons.close_sharp),
            //                   ),
            //           ),
            //           onChanged: (keyword) {
            //             setState(() {
            //               search = dataItems
            //                   .where((element) =>
            //                       element.contains(srcListCtrl.text))
            //                   .toList();
            //             });
            //           },
            //           controller: srcListCtrl,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            //
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
                shrinkWrap: true,
                itemCount: search.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      search[index],
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    trailing: InkWell(
                      child: const Icon(Icons.close_sharp),
                      onTap: () {
                        dataList.deleteDataItem(widget.index, index);
                      },
                    ),
                    onTap: () {},
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.blue,
      //   onPressed: () {
      //     showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return AlertDialog(
      //           title: const Text('Create New Item'),
      //           content: TextField(
      //             controller: newItemCtrl,
      //             decoration: const InputDecoration(hintText: "New List Name"),
      //             autofocus: true,
      //           ),
      //           actions: [
      //             TextButton(
      //               child: const Text(
      //                 'Create',
      //                 style: TextStyle(
      //                   fontSize: 20.0,
      //                 ),
      //               ),
      //               onPressed: () {
      //                 if (!dataItems.contains(newItemCtrl.text) &&
      //                     newItemCtrl.text != "") {
      //                   dataList.addDataItem(widget.index, newItemCtrl.text);
      //                   Navigator.pop(context);
      //                   newItemCtrl.clear();
      //                 } else if (newItemCtrl.text == "") {
      //                   ScaffoldMessenger.of(context).showSnackBar(
      //                     const SnackBar(
      //                       content: Text("Name cannot be blank"),
      //                     ),
      //                   );
      //                 } else {
      //                   ScaffoldMessenger.of(context).showSnackBar(
      //                     const SnackBar(
      //                       content: Text("Name already exists"),
      //                     ),
      //                   );
      //                 }
      //               },
      //             ),
      //           ],
      //           actionsPadding: const EdgeInsets.all(8.0),
      //         );
      //       },
      //     );
      //   },
      //   child: const Icon(
      //     Icons.add,
      //     size: 20.0,
      //   ),
      // ),
    );
  }
}
