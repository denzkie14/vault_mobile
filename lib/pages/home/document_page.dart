import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vault_mobile/constants/color_values.dart';
import 'package:vault_mobile/models/document_model.dart';
import 'package:vault_mobile/pages/home/pdf_view.dart';
import 'package:vault_mobile/widgets/custom_infputfield.dart';

import '../../controllers/document_controller.dart';
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
    // Show the loading dialog
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
      // Fetch new document data from the API
      final newDocument =
          await _controller.fetchDataFromAPI(_document.documentNumber);

      // Close the dialog
      Navigator.of(context).pop();

      // Update the UI if the data is fetched successfully
      if (newDocument != null) {
        setState(() {
          _document = newDocument;
        });
      }
    } catch (e) {
      // Close the dialog in case of an error
      Navigator.of(context).pop();

      // Optionally show an error dialog or snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh document details: $e'),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    // When the back button is pressed, navigate to the Dashboard page
    Get.offAllNamed('/'); // Adjust this to your Dashboard route name
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _onWillPop, // Intercept back button press
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
                      hintText: 'Title',
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      textController:
                          TextEditingController(text: _document.description),
                      hintText: 'Description',
                      maxLines: 4,
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
                        Text('Status: ${_document.actionDisplay}'),
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
                    CircularButton(icon: Icons.history, fn: () {}),
                    const SizedBox(width: 8),
                    CircularButton(
                      icon: Icons.picture_as_pdf,
                      fn: () {
                        Get.to(() => const PdfViewPage());
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
