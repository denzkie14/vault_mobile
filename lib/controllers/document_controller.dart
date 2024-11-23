import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:vault_mobile/models/action_model.dart';
import 'package:vault_mobile/models/document_model.dart';
import 'package:vault_mobile/models/purpose_model.dart';

import '../constants/values.dart';
import '../models/document_log_model.dart';
import '../models/user_model.dart';

class DocumentController extends GetxController {
  // Function to call the API with the scanned value
  final GetStorage storage = GetStorage(); // Instance of GetStorage

  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  var copyOnly = false.obs;
  // var selectedPurpose = ''.obs;
  Rxn<Purpose?> selectedPurpose = Rxn<Purpose?>();
  String remarks = '';

  var scannedOTP = ''.obs;
  String message = '';
  int statusCode = 200;
  var actions = <ActionModel>[].obs;
  Future<DocumentModel?> fetchDataFromAPI(String scannedValue) async {
    User user = User.fromJson(storage.read('user'));
    // try {
    // API Call
    isLoading(true);
    final response = await http.get(
      Uri.parse('$apiUrl/documents/$scannedValue'),
      headers: {'Authorization': 'Bearer  ${user!.token}'},
    );
    debugPrint('$apiUrl/documents/$scannedValue');
    actions.clear();
    isLoading(false);
    if (response.statusCode == 200) {
      statusCode = 200;
      message = 'Record found.';
      var data = jsonDecode(response.body);
      DocumentModel doc = DocumentModel.fromJson(data['data']);
      var dataActions = (data['actions'] as List)
          .map<ActionModel>((a) => ActionModel.fromJson(a))
          .toList();
      actions.addAll(dataActions);
      actions.refresh();
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

  var otpCode = ''.obs;
  var otpMessage = '';
  var isOTPLoading = false.obs;
  // Function to fetch code from API
  Future<bool> fetchCodeFromAPI() async {
    otpCode.value = '';
    otpMessage = '';
    User user = User.fromJson(storage.read('user'));
    isOTPLoading(true);
    final url = Uri.parse('$apiUrl/otp'); // Replace with your API URL
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer  ${user.token}'},
    );
    isOTPLoading(false);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      otpCode.value =
          data['otp']['otp_code']; // Adjust based on API response structure
      return true;
    } else {
      otpMessage = 'Failed to fetch code, please try again.';
      //throw Exception('Failed to fetch code');
      return false;
    }
  }

  String updateMessage = '';
  var isUpdating = false.obs;
  var isUpdatingDocumentLoading = false.obs;
  // Function to fetch code from API
  Future<bool> releaseDocument(
      String documentCode, int actionId, String remarks) async {
    User user = User.fromJson(storage.read('user'));
    isUpdating(true);
    final url = Uri.parse(
        '$apiUrl/documents/log?id=$documentCode&action_id=$actionId&purpose_id=${selectedPurpose.value?.id}&remarks=$remarks&copy_only=${copyOnly.value}&otp=${scannedOTP.value}'); // Replace with your API URL

    debugPrint(url.path);
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer  ${user.token}'},
    );
    isUpdating(false);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      updateMessage = data['message']; // Adjust based on API response structure
      return true;
    }
    if (response.statusCode == 401) {
      updateMessage =
          'Unauthorized access!'; // Adjust based on API response structure
      return false;
    } else {
      updateMessage = json.decode(response.body);
      //throw Exception('Failed to fetch code');
      return false;
    }
  }

  Future<bool> receiveDocument(String documentCode, int actionId,
      String remarks, int purpose_id, String delivery_otp) async {
    User user = User.fromJson(storage.read('user'));
    isUpdating(true);
    final url = Uri.parse(
        '$apiUrl/documents/log?id=$documentCode&action_id=$actionId&purpose_id=$purpose_id&remarks=$remarks&copy_only=${copyOnly.value}&otp=$delivery_otp'); // Replace with your API URL

    debugPrint(url.path);
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer  ${user.token}'},
    );
    isUpdating(false);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      updateMessage = data['message']; // Adjust based on API response structure
      return true;
    }
    if (response.statusCode == 401) {
      updateMessage =
          'Unauthorized access!'; // Adjust based on API response structure
      return false;
    } else {
      updateMessage = json.decode(response.body);
      //throw Exception('Failed to fetch code');
      return false;
    }
  }
}
