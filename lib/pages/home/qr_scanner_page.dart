// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

// class QRScannerPage extends StatefulWidget {
//   @override
//   _QRScannerPageState createState() => _QRScannerPageState();
// }

// class _QRScannerPageState extends State<QRScannerPage>
//     with SingleTickerProviderStateMixin {
//   late MobileScannerController cameraController;
//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize the MobileScannerController
//     cameraController = MobileScannerController();

//     // Initialize the animation controller and animation
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     );

//     _animation = Tween<double>(begin: 0, end: 0.7).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     )..addListener(() {
//         setState(() {});
//       });

//     _animationController.repeat(
//         reverse: true); // Make it repeat and reverse to simulate scanning
//   }

//   @override
//   void dispose() {
//     cameraController.dispose(); // Dispose of the camera controller when done
//     _animationController.dispose(); // Dispose the animation controller
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get screen size and orientation
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     Orientation orientation = MediaQuery.of(context).orientation;

//     // Set square size based on orientation and screen size
//     double squareSize = orientation == Orientation.portrait
//         ? screenWidth * 0.6 // 60% of screen width in portrait mode
//         : screenHeight * 0.6; // 60% of screen height in landscape mode

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Scanner'),
//         actions: [
//           // Button to switch between cameras
//           IconButton(
//             icon: Icon(Icons.switch_camera),
//             onPressed: () {
//               cameraController.switchCamera();
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // QR Scanner camera feed
//           MobileScanner(
//             controller: cameraController,
//             onDetect: (capture) {
//               final List<Barcode> barcodes = capture.barcodes;
//               for (final barcode in barcodes) {
//                 final String? qrCodeData = barcode.rawValue;
//                 if (qrCodeData != null) {
//                   cameraController
//                       .stop(); // Stop the camera once a QR code is detected
//                   Navigator.pop(context, qrCodeData); // Return the QR code data
//                 }
//               }
//             },
//           ),

//           // Center square with scanning line animation
//           Align(
//             alignment: Alignment.center, // Center the square in the middle
//             child: Container(
//               width: squareSize,
//               height: squareSize,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.green, width: 2),
//               ),
//               child: Stack(
//                 children: [
//                   // Animated scanning line inside the square
//                   Positioned(
//                     top: _animation.value *
//                         squareSize, // Animate within the square's height
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       height: 2, // Line thickness
//                       color: Colors.green, // Line color
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
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
      // Re-enable scanning
      setState(() {
        isProcessing = false;
      });
      cameraController.start();
    }
  }
}
