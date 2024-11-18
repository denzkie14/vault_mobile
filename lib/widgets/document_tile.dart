import 'package:flutter/material.dart';
import 'package:vault_mobile/models/document_model.dart';

class DocumentTile extends StatelessWidget {
  const DocumentTile({super.key, required this.document});
  final DocumentModel document;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(document.code),
      subtitle: Text(document.title),
      // trailing: FlutterLogo(),
    );
  }
}
