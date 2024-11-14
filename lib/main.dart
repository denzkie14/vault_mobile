import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'pages/login/login.dart';
import 'services/theme_service.dart';

void main() async {
  await GetStorage.init(); // Initialize GetStorage
  runApp(VaultApp());
}

class VaultApp extends StatelessWidget {
  final ThemeService _themeService = ThemeService();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _themeService.themeNotifier, // Listen to theme changes
      builder: (context, ThemeMode themeMode, child) {
        return MaterialApp(
          title: 'VAULT',
          theme: ThemeService.lightTheme,
          darkTheme: ThemeService.darkTheme,
          themeMode: themeMode,
          home: LoginView(),
        );
      },
    );
  }
}
