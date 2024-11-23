import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vault_mobile/controllers/document_controller.dart';
import 'package:vault_mobile/controllers/theme_controller.dart';
import 'package:vault_mobile/models/document_model.dart';
import 'package:vault_mobile/pages/home/document_page.dart';

class OTP_QRCodeScannerScreen extends StatefulWidget {
  const OTP_QRCodeScannerScreen({Key? key}) : super(key: key);

  @override
  _OTP_QRCodeScannerScreenState createState() =>
      _OTP_QRCodeScannerScreenState();
}

class _OTP_QRCodeScannerScreenState extends State<OTP_QRCodeScannerScreen> {
  final DocumentController qrController = Get.put(DocumentController());
  final ThemeController themeController = Get.put(ThemeController());
  final MobileScannerController cameraController =
      MobileScannerController(autoStart: true); // Initialize controller
  String? scannedCode;
  bool isProcessing = false; // To prevent multiple API calls for the same QR

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP QR Code Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () async {
              cameraController.switchCamera();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Scanner View
          Positioned.fill(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (barcode) {
                final String? code = barcode.barcodes[0].displayValue;
                if (code != null && !isProcessing) {
                  setState(() {
                    scannedCode = code;
                    isProcessing = true;
                  });
                  _handleQRCodeScanned(code);
                }
              },
            ),
          ),
          // Rounded Container on Top
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() {
              return Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: themeController.isDarkMode.value
                      ? Colors.blueGrey
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20), // Top-left corner radius
                    topRight: Radius.circular(20), // Top-right corner radius
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        scannedCode ?? 'Scan a OTP Code',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: _showManualCodeDialog,
                        icon: const Icon(Icons.keyboard),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _showManualCodeDialog() async {
    final TextEditingController codeController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter OTP Code'),
          content: TextField(
            controller: codeController,
            maxLength: 6,
            decoration: const InputDecoration(
              hintText: 'Type OTP Code here',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String code = codeController.text.trim();
                if (code.isNotEmpty) {
                  Navigator.of(context).pop(); // Close dialog
                  _handleQRCodeScanned(code); // Handle code submission
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleQRCodeScanned(String code) async {
    // Stop scanning temporarily
    cameraController.stop();
    Get.back<String>(result: code);
  }
}
