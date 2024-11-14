import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String message; // Parameter for message

  // Constructor to accept a message
  const LoadingDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black
                .withOpacity(0.7), // Add slight opacity to background
            borderRadius:
                BorderRadius.circular(12), // Rounded corners for the dialog
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                  height: 16), // Add space between the spinner and message
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
