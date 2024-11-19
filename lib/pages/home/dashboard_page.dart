import 'package:flutter/material.dart';
import 'package:vault_mobile/models/document_model.dart';

import '../../widgets/document_tile.dart';

class DashboardPage extends StatelessWidget {
  final List<DocumentModel> documents = [];

  // Sample data for the cards and recent transactions
  final Map<String, Map<String, dynamic>> cardData = {
    'Incoming': {
      'value': 20,
      'icon': Icons.arrow_downward, // Icon for Incoming
      'color': Colors.green,
    },
    'Outgoing': {
      'value': 15,
      'icon': Icons.arrow_upward, // Icon for Outgoing
      'color': Colors.red,
    },
    'Pending': {
      'value': 5,
      'icon': Icons.hourglass_empty, // Icon for Pending
      'color': Colors.orange,
    },
    'Completed': {
      'value': 50,
      'icon': Icons.check_circle, // Icon for Completed
      'color': Colors.blue,
    },
  };

  final List<Map<String, String>> transactionData = [
    {
      'transactionNo': 'TX12345',
      'title': 'Invoice Payment',
      'origin': 'Client A',
      'location': 'Office 1',
      'status': 'Completed',
      'action': 'View',
    },
    {
      'transactionNo': 'TX12346',
      'title': 'Order Delivery',
      'origin': 'Vendor B',
      'location': 'Warehouse',
      'status': 'Pending',
      'action': 'View',
    },
    {
      'transactionNo': 'TX12347',
      'title': 'Product Return',
      'origin': 'Client C',
      'location': 'Retail Store',
      'status': 'Outgoing',
      'action': 'View',
    },
    {
      'transactionNo': 'TX12348',
      'title': 'Payment Receipt',
      'origin': 'Client D',
      'location': 'Office 2',
      'status': 'Completed',
      'action': 'View',
    },
  ];

  List<bool> isSelected = [false, false, false];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Responsive cards using GridView
            Expanded(
              flex: 2,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (MediaQuery.of(context).size.width ~/ 200),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: cardData.length,
                itemBuilder: (context, index) {
                  final entry = cardData.entries.elementAt(index);
                  return Card(
                    elevation: 5,
                    color: entry.value['color'],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        //  mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              entry.value['icon'],
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          // SizedBox(height: 8),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${entry.value['value']}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // SizedBox(height: 8),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Recent Transactions Table
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Align(
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
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: documents
                          .map((document) => DocumentTile(document: document))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// void main() {
//   runApp(MaterialApp(
//     home: DashboardPage(),
//   ));
// }
