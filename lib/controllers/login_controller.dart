import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vault_mobile/constants/values.dart';
import 'dart:convert';

import '../models/user_model.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var errorMessage = ''.obs;

  final String loginUrl =
      '$apiUrl/login'; // Replace with your actual API endpoint
  final GetStorage storage = GetStorage(); // Instance of GetStorage

  Future<void> login(String username, String password) async {
    isLoading(true);

    Map<String, String> data = {
      'Username': username,
      'Password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        debugPrint(responseData.toString());

        if (responseData['success'] == true) {
          isLoggedIn(true);
          errorMessage('');

          // Map the response to User model
          User user = User.fromJson(responseData['user']);
          errorMessage(
              'Welcome back ${user.firstName.toUpperCase()}! Press OK to continue.');
          // Save user data to GetStorage
          storage.write('user', user.toJson());
          // saveUserData(user);
        } else {
          errorMessage('${responseData['message']}');
        }
      } else if (response.statusCode == 401) {
        if (Get.isDialogOpen == true) {
          Get.back(); // Close the dialog
        }
        Get.snackbar(
          'Unauthorized',
          'You are not authorized to access this file.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (response.statusCode == 404) {
        Get.snackbar(
          'No Record',
          'Document not found',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        errorMessage('Failed to connect to the server.');
      }
    } catch (e) {
      errorMessage('Error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateToken(String token) async {
    debugPrint('updateToken : updating token: $token');
    try {
      User user = User.fromJson(storage.read('user'));
      final response = await http.put(
        Uri.parse('$apiUrl/fcm/update?token=$token'),
        headers: {'Authorization': 'Bearer  ${user.token}'},

        //body: json.encode(data),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        debugPrint(responseData.toString());

        if (responseData['success'] == true) {
          debugPrint('Token has been updated!');
        } else {
          debugPrint('Error has occured: ${json.decode(response.body)}');
        }
      } else if (response.statusCode == 401) {
        debugPrint('Error has occured: ${json.decode(response.body)}');
      } else if (response.statusCode == 404) {
        debugPrint('Error has occured: ${json.decode(response.body)}');
      } else {
        debugPrint('Error has occured: ${json.decode(response.body)}');
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
    } finally {
      //  isLoading(false);
    }
  }

  // Function to save user data to GetStorage
  // void saveUserData(User user) {
  //   storage.write('user', user.toJson());
  // }

  // Function to retrieve user data from GetStorage
  User? getUserData() {
    var userData = storage.read('user');
    if (userData != null) {
      return User.fromJson(userData);
    }
    return null;
  }
}
