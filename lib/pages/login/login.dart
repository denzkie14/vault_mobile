import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/loading_dialog.dart';

class LoginView extends StatelessWidget {
  final LoginController loginController =
      Get.put(LoginController()); // Controller instance
  final Color customColor = const Color(0xFF0C6496);
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/vault_logo.png',
                  height: isLargeScreen ? 150 : 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text(
                  'VAULT',
                  style: TextStyle(
                    fontSize: isLargeScreen ? 32 : 24,
                    fontWeight: FontWeight.bold,
                    color: customColor,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person, color: customColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, color: customColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 4) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: isLargeScreen ? 300 : double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Show loading dialog
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => const LoadingDialog(
                              message: 'Logging in... Please wait'),
                        );

                        // Trigger login using the controller
                        await loginController.login(
                          _usernameController.text,
                          _passwordController.text,
                        );

                        // Close the loading dialog
                        Navigator.of(context).pop();

                        // Show result dialog
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ResultDialog(
                              title: loginController.isLoggedIn.value
                                  ? 'Login Successful'
                                  : 'Login Failed',
                              message: loginController.isLoggedIn.value
                                  ? 'Welcome back!'
                                  : loginController.errorMessage.value,
                              isSuccess: loginController.isLoggedIn.value,
                              onSuccess: () {
                                // Navigate to the next page after successful login
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: customColor,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
