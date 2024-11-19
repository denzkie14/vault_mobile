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
      body: Column(
        children: [
          Expanded(
            flex: 4,
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
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                scannedCode ?? 'Scan a Document Code',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
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
      final DocumentModel? document = await qrController.fetchDataFromAPI(code);

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
        // Handle null document (e.g., show error)
        if (mounted) {
          Get.snackbar(
            'Error',
            'Document not found',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      // Dismiss loading dialog and show error
      if (mounted) Navigator.of(context).pop();
      Get.snackbar(
        'Error',
        'Failed to fetch document: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // Re-enable scanning after navigation (start camera if user navigates back)
      setState(() {
        isProcessing = false;
      });
      //  cameraController.start();
    }
  }
}
