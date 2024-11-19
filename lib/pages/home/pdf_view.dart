import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewPage extends StatefulWidget {
  const PdfViewPage({Key? key}) : super(key: key);

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  bool _isLoading = true;
  File? _pdfFile; // Make the file nullable
  String message = '';
  // Replace with your actual token
  final String _bearerToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJqb2huIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQWRtaW5pc3RyYXRvciIsImp0aSI6ImJjMzExNDA3LTI5MDEtNGQ2OS05ZDZjLTM3MTI4MDQ5NDI2ZCIsImV4cCI6MTczMjA1NzE5MCwiaXNzIjoidmF1bHQudGVjaG5vYmVzdC5jb20iLCJhdWQiOiJ2YXVsdC50ZWNobm9iZXN0LmNvbSJ9.vGZ-8iU8HIUEnIPeFCAsvZZ3d_X-Sy5iRZ2-oklYays';

  @override
  void initState() {
    super.initState();
    _fetchPdfFromApi();
  }

  Future<void> _fetchPdfFromApi() async {
    try {
      // Replace with your API endpoint
      const String apiUrl =
          "http://192.168.2.244/vault/api/files/PIO2024000010";

      // Add Authorization header with Bearer token
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $_bearerToken', // Add the Bearer token here
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String base64Pdf = data['FileContent']; // Extract Base64 string

        // Decode Base64 and save to a temporary file
        final bytes = base64Decode(base64Pdf);
        final Directory tempDir = await getTemporaryDirectory();
        final File tempFile = File('${tempDir.path}/temp.pdf');
        await tempFile.writeAsBytes(bytes);

        setState(() {
          _pdfFile = tempFile; // Assign the file
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("PDF loaded successfully!")),
        );
      } else {
        setState(() {
          message = json.decode(response.body);
        });

        throw Exception("Failed to load PDF");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading PDF: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_pdfFile != null
              ? SfPdfViewer.file(_pdfFile!)
              : Center(
                  child: Text(
                  message,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ))), // Handle null case
    );
  }
}
