import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import '../../app/app.dart';
import '../../data/settings.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    Settings settings = context.watch<Settings>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          SwitchListTile(
            title: const Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            value: settings.darkMode,
            onChanged: (value) {
              if (settings.darkMode) {
                MainApp.of(context)?.changeTheme(ThemeMode.dark);
              } else {
                MainApp.of(context)?.changeTheme(ThemeMode.light);
              }
              settings.changeTheme();
            },
            secondary: const Icon(
              Icons.light_mode,
              size: 28.0,
            ),
            activeColor: Colors.blue,
            activeTrackColor: Colors.lightBlueAccent,
          ),
          const Divider(),
          Link(
            uri: Uri.parse('https://github.com/BuildTheOne/randomizer_app'),
            builder: (context, followLink) {
              return ListTile(
                onTap: followLink,
                title: const Text(
                  'Source code',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                leading: const Icon(
                  Icons.code,
                  size: 28.0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
