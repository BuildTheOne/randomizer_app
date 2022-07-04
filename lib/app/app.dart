import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screen/home/home.dart';
import '../screen/settings/settings.dart';
import '../data/settings.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();

  static _MainAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainAppState>();
}

class _MainAppState extends State<MainApp> {
  ThemeMode themeMode = ThemeMode.dark;
  final pageCtrl = PageController();
  int screenIndex = 0;

  final List<Widget> screenList = [
    const HomeScreen(),
    const SettingScreen(),
  ];

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      this.themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Settings settings = context.watch<Settings>();
    if (settings.darkMode) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }

    return MaterialApp(
      title: 'Randomizer',
      theme: ThemeData(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: themeMode,
      home: Scaffold(
        body: PageView(
          controller: pageCtrl,
          children: screenList,
          onPageChanged: (index) {
            setState(() {
              screenIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.green,
            ),
          ],
          currentIndex: screenIndex,
          selectedItemColor: Colors.blue[400],
          onTap: (index) {
            setState(() {
              pageCtrl.animateToPage(
                index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceOut,
              );
              screenIndex = index;
            });
          },
        ),
      ),
    );
  }
}
