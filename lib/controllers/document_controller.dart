import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:vault_mobile/models/action_model.dart';
import 'package:vault_mobile/models/document_model.dart';

import '../constants/values.dart';
import '../models/document_log_model.dart';
import '../models/user_model.dart';

class DocumentController extends GetxController {
  // Function to call the API with the scanned value
  final GetStorage storage = GetStorage(); // Instance of GetStorage

  User? user;
  String message = '';
  int statusCode = 200;
  List<ActionModel> actions = <ActionModel>[].obs;
  Future<DocumentModel?> fetchDataFromAPI(String scannedValue) async {
    User user = User.fromJson(storage.read('user'));
    // try {
    // API Call
    final response = await http.get(
      Uri.parse('$apiUrl/documents/$scannedValue'),
      headers: {'Authorization': 'Bearer  ${user!.token}'},
    );

    actions.clear();

    if (response.statusCode == 200) {
      statusCode = 200;
      message = 'Record found.';
      var data = jsonDecode(response.body);
      DocumentModel doc = DocumentModel.fromJson(data['data']);
      var dataActions = (data['actions'] as List)
          .map<ActionModel>((a) => ActionModel.fromJson(a))
          .toList();
      actions.addAll(dataActions);
      return doc; // Return the parsed document
    } else if (response.statusCode == 404) {
      statusCode = 404;
      message = 'No record found.';
    } else if (response.statusCode == 401) {
      statusCode = 401;
      message = 'You have no access to this file.';
    } else {
      statusCode = 400;
      message = 'Unkown error occured, please try again later.';
    }
    // }
    // catch (e) {
    //   Get.snackbar(
    //     'An error occured!',
    //     'An unexpected error occurred: $e',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // }
    return null; // Return null in case of an error
  }

  // Fetch Document Logs by Document Number
  Future<List<DocumentLog>> fetchDocumentLogs(String documentNumber) async {
    User user = User.fromJson(storage.read('user'));

    final response = await http.get(
      Uri.parse('$apiUrl/documents/logs/$documentNumber'),
      headers: {'Authorization': 'Bearer  ${user!.token}'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<DocumentLog> logs = (data['logs'] as List)
          .map((log) => DocumentLog.fromJson(log))
          .toList();
      return logs; // Return the parsed logs
    } else if (response.statusCode == 404) {
      Get.snackbar(
        'An error occurred!',
        'No logs found for this document',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'An error occurred!',
        'API call failed: ${response.statusCode}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return []; // Return an empty list in case of an error
  }
}
