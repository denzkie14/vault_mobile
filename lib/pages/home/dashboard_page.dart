import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:vault_mobile/models/document_model.dart';

import '../../controllers/dashboard_controller.dart';
import '../../controllers/document_controller.dart';
import '../../widgets/document_tile.dart';
import 'document_page.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
//  OrderController().load();
}

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<DocumentModel> documents = [];

  final _controller = Get.put(DashboardController());

  final _documentController = Get.put(DocumentController());

  // Sample data for the cards and recent transactions
  List<String> dashboard = [
    'Incoming',
    'Outgoing',
    'Pending',
    'Completed',
    'Disapproved'
  ];

  List<bool> isSelected = [false, false, false];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    _controller.fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
              onPressed: () {
                _showQRCodeBottomSheet(context);
              },
              icon: const Icon(Icons.qr_code)),
          IconButton(
              onPressed: () {
                _controller.fetchDashboardData();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Responsive cards using GridView
            Expanded(
              flex: 2,
              child: Obx(() {
                return _controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              (MediaQuery.of(context).size.width ~/ 200),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: dashboard.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _card(
                                dashboard[index],
                                _controller.incoming.value,
                                Colors.blue,
                                Icons.download);
                          } else if (index == 1) {
                            return _card(
                                dashboard[index],
                                _controller.outgoing.value,
                                Colors.red,
                                Icons.upload);
                          } else if (index == 2) {
                            return _card(
                                dashboard[index],
                                _controller.pending.value,
                                Colors.orangeAccent,
                                Icons.pending_actions);
                          } else if (index == 3) {
                            return _card(
                                dashboard[index],
                                _controller.completed.value,
                                Colors.green,
                                Icons.check_circle);
                          }
                        },
                      );
              }),
            ),

            // Recent Transactions Table
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text(
                          'Recent Transactions',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    return _controller.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: _controller.recents
                                  .map((document) => InkWell(
                                      onTap: () {
                                        Get.to(() => DocumentDetails(
                                            document: document));
                                      },
                                      child: DocumentTile(document: document)))
                                  .toList(),
                            ),
                          );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(String label, int count, Color color, IconData icon) {
    return Card(
      elevation: 5,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          //  mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
            ),
            // SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show BottomSheet with Syncfusion QR code
  void _showQRCodeBottomSheet(BuildContext context) async {
    try {
      _documentController.fetchCodeFromAPI();
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _documentController.isOTPLoading.value
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.height / 3,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.height / 3,
                          child: SfBarcodeGenerator(
                            value: _documentController.otpCode.value,
                            symbology: QRCode(),
                            showValue:
                                false, // Hides the code text below the QR code
                            //size: const Size(200, 200),
                          ),
                        ),
                  const SizedBox(height: 16),
                  _documentController.isOTPLoading.value
                      ? const Text(
                          'Generating OTP, please wait...',
                        )
                      : Column(
                          children: [
                            Text(
                              _documentController.otpCode.value,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'This OTP is valid for 3 minutes only',
                              style: TextStyle(
                                fontSize: 14,
                                //  fontWeight: FontWeight.it,
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: () => _documentController.fetchCodeFromAPI(),
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                ],
              );
            }),
          );
        },
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching code: $error')),
      );
    }
  }
}


// void main() {
//   runApp(MaterialApp(
//     home: DashboardPage(),
//   ));
// }
