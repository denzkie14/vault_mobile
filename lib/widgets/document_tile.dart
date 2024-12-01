import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vault_mobile/models/document_model.dart';

class DocumentTile extends StatelessWidget {
  const DocumentTile({super.key, required this.document});
  final DocumentModel document;
  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('MMM dd, yyyy').format(document.dateCreated!);
    String formattedTime =
        DateFormat('hh:mm:ss a').format(document.dateCreated!);
    return Card(
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: 130,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          document.documentNumber,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          document.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Origin: ${document.origin}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Location: ${document.location}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: Text(
                        document.actionDisplay,
                        style: const TextStyle(
                          color: Colors.white, // Dynamic text color
                        ),
                      ),
                      labelStyle: const TextStyle(color: Colors.white),
                      selected: true,
                      selectedColor: document.action.toLowerCase() == 'receive'
                          ? Colors.blue
                          : document.action.toLowerCase() == 'release'
                              ? Colors.yellow
                              : document.action.toLowerCase() == 'approve'
                                  ? Colors.green
                                  : document.action.toLowerCase() ==
                                          'disapprove'
                                      ? Colors.red
                                      : Colors
                                          .black, // Background color when selected
                    ),
                    Text(formattedDate),
                    Text(formattedTime)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
