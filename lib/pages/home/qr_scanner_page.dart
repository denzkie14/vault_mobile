import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vault_mobile/controllers/document_controller.dart';
import 'package:vault_mobile/models/document_model.dart';
import 'package:vault_mobile/pages/home/document_page.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({Key? key}) : super(key: key);

  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  final DocumentController qrController = Get.put(DocumentController());
  final MobileScannerController cameraController =
      MobileScannerController(autoStart: true); // Initialize controller
  String? scannedCode;
  bool isProcessing = false; // To prevent multiple API calls for the same QR

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
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
            child: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
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
                      scannedCode ?? 'Scan a Document Code',
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
            ),
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
          title: const Text('Enter Document Code'),
          content: TextField(
            controller: codeController,
            decoration: const InputDecoration(
              hintText: 'Type the code here',
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

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Fetch data from API
      final DocumentModel? document = await qrController
          .fetchDataFromAPI(code)
          .timeout(const Duration(seconds: 60), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, please try again later.');
      });

      // Dismiss loading dialog
      if (mounted) Get.back();

      if (document != null) {
        // Dispose the camera before navigation
        cameraController.dispose(); // Ensure camera resources are released

        // Redirect to DocumentDetails page
        if (mounted) {
          Get.to(() => DocumentDetails(document: document));
        }
      } else {
        Get.snackbar(
          qrController.statusCode == 401 ? 'Unauthorized Access' : 'Error',
          qrController.message,
          snackPosition: SnackPosition.BOTTOM,
        );

        cameraController.start();
      }
    } on TimeoutException catch (e) {
      if (mounted) Get.back();
      Get.snackbar(
        'An error occured!',
        'Request timed out.',
        snackPosition: SnackPosition.BOTTOM,
      );

      cameraController.start();
    } catch (e) {
      debugPrint('Error: $e');

      // Dismiss loading dialog and show error
      if (mounted) Get.back();
      Get.snackbar(
        'An error occured!',
        'Failed to fetch document: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      cameraController.start();
    } finally {
      if (Get.isDialogOpen == true) {
        Get.back(); // Close the dialog
      }
      // Re-enable scanning after navigation (start camera if user navigates back)
      setState(() {
        isProcessing = false;
        scannedCode = 'Scan a Document Code';
      });
    }
  }
}
