import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user_model.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var errorMessage = ''.obs;

  final String loginUrl =
      'http://192.168.2.244/api/login'; // Replace with your actual API endpoint

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
        debugPrint(responseData);

        if (responseData['success'] == 'success') {
          isLoggedIn(true);
          errorMessage('');

          // Map the response to User model
          User user = User.fromJson(
              responseData['user']); // Assuming the user data is inside 'data'

          // Save the user data or update state
          // Example: save user to a state management or local storage
          // userController.saveUser(user); // Example with state management
        } else {
          errorMessage('Login failed: ${responseData['message']}');
        }
      } else {
        errorMessage('Failed to connect to the server.');
      }
    } catch (e) {
      errorMessage('Error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
