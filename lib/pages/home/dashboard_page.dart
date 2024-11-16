import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for the cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: cardData.entries.map((entry) {
                return Card(
                  elevation: 5,
                  color: entry.value['color'],
                  child: Container(
                    width: 150,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          entry.value['icon'],
                          size: 40,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Text(
                          entry.key,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${entry.value['value']}',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            // Recent Transactions Table
            Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Transaction #')),
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Origin')),
                  DataColumn(label: Text('Location')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Action')),
                ],
                rows: transactionData.map((transaction) {
                  return DataRow(cells: [
                    DataCell(Text(transaction['transactionNo']!)),
                    DataCell(Text(transaction['title']!)),
                    DataCell(Text(transaction['origin']!)),
                    DataCell(Text(transaction['location']!)),
                    DataCell(Text(transaction['status']!)),
                    DataCell(TextButton(
                      onPressed: () {
                        // Handle the action (e.g., show details)
                        print(
                            'Viewing details of ${transaction['transactionNo']}');
                      },
                      child: Text(transaction['action']!),
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DashboardPage(),
  ));
}
