import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(BuildContext context,
    {required String message,
    String title = 'Confirmation',
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel'}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false, // Prevents dismissing by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                title), // Use the custom title or default to "Confirmation"
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Return false
                style: TextButton.styleFrom(
                  foregroundColor: Colors
                      .grey, // Explicitly set the Cancel button text color to grey
                ),
                child: Text(
                    cancelLabel), // Use the custom label or default to "Cancel"
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Return true
                child: Text(
                    confirmLabel), // Use the custom label or default to "Confirm"
              ),
            ],
          );
        },
      ) ??
      false; // Default to false if dialog is dismissed
}
