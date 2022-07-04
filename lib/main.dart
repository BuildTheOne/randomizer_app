import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/datalist.dart';
import 'data/settings.dart';
import 'app/app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Settings>(create: (ctx) => Settings()),
        ChangeNotifierProvider<DataList>(create: (ctx) => DataList())
      ],
      child: const MainApp(),
    ),
  );
}
