import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(BuildContext context,
    {required String message}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false, // Prevents dismissing by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Return false
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Return true
                child: Text('Confirm'),
              ),
            ],
          );
        },
      ) ??
      false; // Default to false if dialog is dismissed
}
