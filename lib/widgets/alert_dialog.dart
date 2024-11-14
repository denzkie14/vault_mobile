import 'package:flutter/material.dart';

class ResultDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool isSuccess;
  final VoidCallback onSuccess;

  const ResultDialog({
    required this.title,
    required this.message,
    required this.isSuccess,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (isSuccess) {
              onSuccess();
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
