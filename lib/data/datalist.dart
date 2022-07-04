import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DataList extends ChangeNotifier {
  SharedPreferences? prefs;
  List<String> data = [];

  DataList() {
    initPrefs();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    data = prefs?.getStringList("data") ?? [];
    setData(data);
  }

  setData(List<String> data) async {
    prefs?.setStringList('data', data);
    notifyListeners();
  }

  addData(Map<String, dynamic> newData) {
    data.add(jsonEncode(newData));
    setData(data);
  }

  renameData(String newName, int index) {
    Map<String, dynamic> dataChosen = jsonDecode(data.elementAt(index));
    dataChosen['name'] = newName;
    data.replaceRange(index, index + 1, [jsonEncode(dataChosen)]);
    setData(data);
  }

  deleteData(int index) {
    data.removeAt(index);
    setData(data);
  }

  addDataItem(int index, String newData) {
    Map<String, dynamic> dataChosen = jsonDecode(data.elementAt(index));
    List<String> dataItems = List<String>.from(dataChosen['data']);
    //
    dataItems.add(newData);
    dataItems.sort(((a, b) => a.compareTo(b)));
    //
    dataChosen['data'] = dataItems;
    data.replaceRange(index, index + 1, [jsonEncode(dataChosen)]);
    setData(data);
  }

  deleteDataItem(int indexData, int indexItem) {
    Map<String, dynamic> dataChosen = jsonDecode(data.elementAt(indexData));
    dataChosen['notChosen'].remove(dataChosen['data'].removeAt(indexItem));
    data.replaceRange(indexData, indexData + 1, [jsonEncode(dataChosen)]);
    setData(data);
  }

  chooseItem(int indexData, String chosenItem) {
    Map<String, dynamic> dataChosen = jsonDecode(data.elementAt(indexData));
    dataChosen['chosen'].add(chosenItem);
    dataChosen['notChosen'].remove(chosenItem);
    data.replaceRange(indexData, indexData + 1, [jsonEncode(dataChosen)]);
    setData(data);
  }

  removeChosen(int index, String chosenItem) {
    Map<String, dynamic> dataChosen = jsonDecode(data.elementAt(index));
    dataChosen['notChosen'].remove(chosenItem);
    data.replaceRange(index, index + 1, [jsonEncode(dataChosen)]);
    setData(data);
  }

  refreshChosen(int index) {
    Map<String, dynamic> dataChosen = jsonDecode(data.elementAt(index));
    //
    dataChosen['chosen'].clear();
    dataChosen['notChosen'] = dataChosen['data'];
    //
    data.replaceRange(index, index + 1, [jsonEncode(dataChosen)]);
    setData(data);
  }

  settingSave(int index, String num) {
    Map<String, dynamic> dataChosen = jsonDecode(data.elementAt(index));
    //
    dataChosen['number'] = int.parse(num);
    //
    data.replaceRange(index, index + 1, [jsonEncode(dataChosen)]);
    setData(data);
  }
}
