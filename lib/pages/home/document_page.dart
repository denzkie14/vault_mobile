import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vault_mobile/constants/color_values.dart';
import 'package:vault_mobile/models/document_model.dart';
import 'package:vault_mobile/pages/home/pdf_view.dart';
import 'package:vault_mobile/widgets/custom_infputfield.dart';

import '../../controllers/document_controller.dart';
import '../../models/document_log_model.dart';
import '../../widgets/circular_button.dart';

class DocumentDetails extends StatefulWidget {
  final DocumentModel document;

  const DocumentDetails({Key? key, required this.document}) : super(key: key);

  @override
  State<DocumentDetails> createState() => _DocumentDetailsState();
}

class _DocumentDetailsState extends State<DocumentDetails> {
  late DocumentModel _document;
  final DocumentController _controller = DocumentController();

  @override
  void initState() {
    super.initState();
    _document = widget.document;
  }

  Future<void> _refreshDocumentDetails() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final newDocument =
          await _controller.fetchDataFromAPI(_document.documentNumber);

      Navigator.of(context).pop();

      if (newDocument != null) {
        setState(() {
          _document = newDocument;
        });
      }
    } catch (e) {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh document details: $e'),
        ),
      );
    }
  }

  Future<void> _fetchAndShowDocumentLogs() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<DocumentLog>>(
          future: _controller.fetchDocumentLogs(_document.documentNumber),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching logs: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No logs found.'),
              );
            } else {
              final logs = snapshot.data!;

              return ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];

                  // Format the date as "MMM dd, yyyy hh:mm:ss a"
                  String formattedDate = DateFormat('MMM dd, yyyy hh:mm:ss a')
                      .format(log.dateActed);

                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(log.actionLabel),
                    subtitle: Text('By: ${log.actedBy} @ ${formattedDate}'),
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    Get.offAllNamed('/');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String formattedDate =
        DateFormat('MMM dd, yyyy hh:mm:ss a').format(_document.lastUpdated);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            _document.documentNumber,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            IconButton(
              onPressed: _refreshDocumentDetails,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        floatingActionButton: Obx(() {
          return SpeedDial(
            icon: Icons.apps,
            activeIcon: Icons.close,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            children: _controller.actions.map<SpeedDialChild>((action) {
              return SpeedDialChild(
                child: action.action_id == 6
                    ? Icon(Icons.check)
                    : action.action_id == 2
                        ? Icon(Icons.outbound)
                        : action.action_id == 3
                            ? Icon(Icons.download)
                            : action.action_id == 4
                                ? Icon(Icons.thumb_up)
                                : action.action_id == 5
                                    ? Icon(Icons.thumb_down)
                                    : Icon(Icons.restore),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                label: action.label,
                labelStyle: TextStyle(fontSize: 18),
                onTap: () {
                  // Handle the action when tapped
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(action.label)),
                  );
                },
              );
            }).toList(),
          );
        }),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size.width,
                height: size.height - 110,
                padding: const EdgeInsets.only(right: 12, left: 12, top: 36),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    CustomTextFormField(
                      textController:
                          TextEditingController(text: _document.title),
                      readOnly: true,
                      hintText: 'Title',
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      textController:
                          TextEditingController(text: _document.description),
                      hintText: 'Description',
                      readOnly: true,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      textController:
                          TextEditingController(text: _document.documentType),
                      readOnly: true,
                      hintText: 'Document Type',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Origin: ${_document.originName}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Location: ${_document.locationName}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Created By: ${_document.createdBy}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Security: ${_document.securityDescription}'),
                        SizedBox(
                          width: 16,
                        ),
                        _document.securityId == 1
                            ? const Icon(Icons.public)
                            : _document.securityId == 2
                                ? const Icon(Icons.safety_check)
                                : const Icon(Icons.lock),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            'Status: ${_document.actionDisplay} @ ${formattedDate}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircularButton(
                      icon: Icons.history,
                      fn: _fetchAndShowDocumentLogs,
                    ),
                    const SizedBox(width: 8),
                    CircularButton(
                      icon: Icons.picture_as_pdf,
                      fn: () {
                        Get.to(
                            () => PdfViewPage(code: _document.documentNumber));
                        debugPrint('Navigate file view');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
