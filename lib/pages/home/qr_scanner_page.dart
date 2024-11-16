import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage>
    with SingleTickerProviderStateMixin {
  late MobileScannerController cameraController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the MobileScannerController
    cameraController = MobileScannerController();

    // Initialize the animation controller and animation
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {});
      });

    _animationController.repeat(
        reverse: true); // Make it repeat and reverse to simulate scanning
  }

  @override
  void dispose() {
    cameraController.dispose(); // Dispose of the camera controller when done
    _animationController.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size and orientation
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    // Set square size based on orientation and screen size
    double squareSize = orientation == Orientation.portrait
        ? screenWidth * 0.6 // 60% of screen width in portrait mode
        : screenHeight * 0.6; // 60% of screen height in landscape mode

    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: [
          // Button to switch between cameras
          IconButton(
            icon: Icon(Icons.switch_camera),
            onPressed: () {
              cameraController.switchCamera();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // QR Scanner camera feed
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? qrCodeData = barcode.rawValue;
                if (qrCodeData != null) {
                  cameraController
                      .stop(); // Stop the camera once a QR code is detected
                  Navigator.pop(context, qrCodeData); // Return the QR code data
                }
              }
            },
          ),

          // Center square with scanning line animation
          Align(
            alignment: Alignment.center, // Center the square in the middle
            child: Container(
              width: squareSize,
              height: squareSize,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Stack(
                children: [
                  // Animated scanning line inside the square
                  Positioned(
                    top: _animation.value *
                        squareSize, // Animate within the square's height
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2, // Line thickness
                      color: Colors.green, // Line color
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
}
