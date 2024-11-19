import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vault_mobile/models/document_model.dart';

import '../constants/values.dart';

class DocumentController extends GetxController {
  // Function to call the API with the scanned value
  Future<DocumentModel?> fetchDataFromAPI(String scannedValue) async {
    try {
      // API Call
      final response = await http.get(
        Uri.parse('$apiUrl/documents/$scannedValue'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        DocumentModel doc = DocumentModel.fromJson(data['data']);
        return doc; // Return the parsed document
      } else if (response.statusCode == 404) {
        Get.snackbar(
          'Error',
          'Document not found',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'API call failed: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on SocketException {
      Get.snackbar(
        'Error',
        'No Internet connection. Please check your network.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FormatException {
      Get.snackbar(
        'Error',
        'Invalid response format from the server.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return null; // Return null in case of an error
  }
}
