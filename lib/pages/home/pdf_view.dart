import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:vault_mobile/models/user_model.dart';

import '../../constants/values.dart';

class PdfViewPage extends StatefulWidget {
  const PdfViewPage({Key? key, required this.code}) : super(key: key);
  final String code;

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  final GetStorage storage = GetStorage(); // Instance of GetStorage

  bool _isLoading = true;
  File? _pdfFile;
  String message = '';
  double _zoomLevel = 1.0;
  int _currentPage = 1; // Initialize to 1 as the first page
  int _totalPages = 0; // Initialize to 0
  final PdfViewerController _pdfViewerController = PdfViewerController();
  late String _bearerToken;
  late User user;

  @override
  void initState() {
    super.initState();
    user = User.fromJson(storage.read('user'));

    _bearerToken = user.token;
    _fetchPdfFromApi();
  }

  Future<void> _fetchPdfFromApi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String url = "$apiUrl/files/${widget.code}";
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $_bearerToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String base64Pdf = data['FileContent'];
        final bytes = base64Decode(base64Pdf);
        final Directory tempDir = await getTemporaryDirectory();
        final File tempFile = File('${tempDir.path}/temp.pdf');
        await tempFile.writeAsBytes(bytes);

        setState(() {
          _pdfFile = tempFile;
          _isLoading = false;
        });

        Get.snackbar(
          'File loaded',
          'PDF loaded successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (response.statusCode == 401) {
        setState(() {
          _isLoading = false;
          message = response.body;
        });
        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (response.statusCode == 404) {
        setState(() {
          _isLoading = false;
          message = 'File not found.';
        });
        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        setState(() {
          _isLoading = false;
          message = json.decode(response.body);
        });
        throw Exception("Failed to load PDF");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        message = e.toString();
      });
      Get.snackbar(
        'An error occurred',
        'Error loading PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel += 0.25;
    });
  }

  void _zoomOut() {
    setState(() {
      if (_zoomLevel > 0.5) _zoomLevel -= 0.25;
    });
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages) {
      _pdfViewerController.nextPage();
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      _pdfViewerController.previousPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPdfFromApi,
            tooltip: 'Refresh Document',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_pdfFile != null
              ? Stack(
                  children: [
                    SfPdfViewer.file(
                      _pdfFile!,
                      controller: _pdfViewerController,
                      onZoomLevelChanged: (details) {
                        setState(() {
                          _zoomLevel = details.newZoomLevel;
                        });
                      },
                      onPageChanged: (details) {
                        setState(() {
                          _currentPage = details.newPageNumber;
                        });
                      },
                      onDocumentLoaded: (details) {
                        setState(() {
                          _totalPages = details.document.pages.count;
                        });
                      },
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _goToPreviousPage,
                            child: const Text("Previous"),
                          ),
                          Text(
                            "Page $_currentPage / $_totalPages",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: _goToNextPage,
                            child: const Text("Next"),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    message,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
    );
  }
}
