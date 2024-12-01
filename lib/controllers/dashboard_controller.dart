import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:vault_mobile/constants/values.dart';
import 'package:vault_mobile/models/document_model.dart';

import '../models/user_model.dart';

class DashboardController extends GetxController {
  final GetStorage storage = GetStorage();
  var toggleButtonIndex = 0.obs;
  List<bool> isSelected = [true, false, false];
  var recents = <DocumentModel>[].obs;
  // Observables for API data
  var incoming = 0.obs;
  var outgoing = 0.obs;
  var completed = 0.obs;
  var pending = 0.obs;
  var disapproved = 0.obs;

  // Loading indicator
  var isLoading = false.obs;

  updateButtonIndex(int index) {
    toggleButtonIndex(index);
  }

  // Fetch dashboard data from API
  Future<void> fetchDashboardData() async {
    try {
      User user = User.fromJson(storage.read('user'));
      isLoading(true);

      final response = await http.get(
        Uri.parse('$apiUrl/dashboard'),
        headers: {'Authorization': 'Bearer  ${user.token}'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Update observables with API data
        incoming.value = data['Incoming'];
        outgoing.value = data['Outgoing'];
        completed.value = data['Completed'];
        pending.value = data['Pending'];
        disapproved.value = data['Disapproved'];

        List<DocumentModel> docs = (data['Recent'] as List)
            .map((d) => DocumentModel.fromJson(d))
            .toList();

        recents.clear();
        recents.addAll(docs);
        recents.refresh();
      } else {
        Get.snackbar('Error', 'Failed to fetch dashboard data');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching data');
      incoming.value = 0;
      outgoing.value = 0;
      completed.value = 0;
      pending.value = 0;
      disapproved.value = 0;
      recents.clear();
    } finally {
      isLoading(false);
    }
  }
}
