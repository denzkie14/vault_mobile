import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Scanner')),
      body: Center(
        child: MobileScanner(
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              final String? qrCodeData = barcode.rawValue;
              if (qrCodeData != null) {
                Navigator.pop(context,
                    qrCodeData); // Return QR data to the previous screen
              }
            }
          },
        ),
      ),
    );
  }
}
