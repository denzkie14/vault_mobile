import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/document_controller.dart';
import '../models/purpose_model.dart';

final List<String> dropdownOptions = [
  'FACILITATION/APPROPRIATE ACTION',
  'YOUR INFORMATION',
  'FOR APPROVAL',
  'REVIEW & COMMENT',
  'KINDLY SEE ME ABOUT THIS',
  'RECOMMENDATION',
  'COORDINATION WITH OFFICES CONCERNED',
];

// Add a DropdownButton in your widget
class PurposeDropDown extends StatefulWidget {
  @override
  _PurposeDropDownState createState() => _PurposeDropDownState();
}

class _PurposeDropDownState extends State<PurposeDropDown> {
  // Purpose? selectedPurpose;
  final DocumentController _controller = Get.put(DocumentController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButtonFormField<Purpose>(
        value: _controller.selectedPurpose.value,
        hint: const Text('Select a purpose'),
        isExpanded: true,
        items: Purpose.getPurposes().map((Purpose purpose) {
          return DropdownMenuItem<Purpose>(
            value: purpose,
            child: Text(purpose.description),
          );
        }).toList(),
        onChanged: (Purpose? value) {
          _controller.selectedPurpose.value = value;
        },
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
        validator: (value) => value == null ? 'Please select a purpose' : null,
      );
    });
  }
}
