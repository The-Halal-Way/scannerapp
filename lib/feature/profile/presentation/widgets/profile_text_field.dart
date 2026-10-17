import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.editing,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool editing;
  final TextInputType? keyboardType;
  final int maxLines;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: !editing,
      showCursor: editing,
      enableInteractiveSelection: editing,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: keyboardType == TextInputType.emailAddress
          ? TextCapitalization.none
          : TextCapitalization.words,
      validator: validator,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
