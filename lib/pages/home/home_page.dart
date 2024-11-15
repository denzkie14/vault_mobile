import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_page.dart';
import 'qr_scanner_page.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  void _onItemTapped(int index) {
    if (index != 1) {
      _selectedIndex.value = index;
      switch (index) {
        case 0:
          Get.toNamed('/dashboard');
          break;
        case 2:
          Get.toNamed('/settings');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, index, child) {
          switch (index) {
            case 0:
              return DashboardPage();
            case 1:
              return QRScannerPage();
            case 2:
              return SettingsPage();
            default:
              return DashboardPage();
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: SizedBox.shrink(), // Placeholder for the scan button
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex.value,
          onTap: _onItemTapped,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectedIndex.value = 1;
          Get.toNamed('/scan');
        },
        child: Icon(Icons.qr_code_scanner),
        tooltip: 'Scan',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
