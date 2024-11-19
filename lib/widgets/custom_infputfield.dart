import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/color_values.dart';
import '../constants/values.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      required this.textController,
      this.hintText,
      this.obscureText,
      this.validator,
      this.maxLines,
      this.submit,
      this.keyboardType,
      this.inputFormatters,
      this.enabled,
      this.maxLength,
      this.readOnly,
      this.suffix,
      this.textAlign})
      : super(key: key);
  final TextEditingController textController;
  final bool? obscureText;
  final String? hintText;
  final int? maxLength;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function(String?)? submit;
  final bool? enabled;
  final bool? readOnly;
  final Widget? suffix;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        textAlign: textAlign ?? TextAlign.start,
        readOnly: readOnly ?? false,
        maxLength: maxLength,
        enabled: enabled ?? true,
        maxLines: maxLines,
        onFieldSubmitted: submit,
        validator: validator,
        obscureText: obscureText ?? false,
        controller: textController,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          suffix: suffix,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor, width: 1.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(defaultBorderRadius),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor, width: 1.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(defaultBorderRadius),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor, width: 1.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(defaultBorderRadius),
            ),
          ),
          hintText: hintText,
        ));
  }
}
