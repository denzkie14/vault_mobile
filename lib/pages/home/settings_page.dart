import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: Obx(() {
          return SwitchListTile(
            title: Text('Dark Mode'),
            value: themeController.isDarkMode.value,
            onChanged: (value) => themeController.toggleTheme(),
          );
        }),
      ),
    );
  }
}
