// ignore_for_file: file_names

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomField extends StatelessWidget {
  CustomField(
      {Key? key,
      required this.label,
      this.textInputType,
      required this.read,
      this.value,
      this.mdp = false,
      this.controller,
      this.suffix,
      this.onChanged,
      this.validator,
      this.onTap})
      : super(key: key);
  String label;
  String? value;
  TextEditingController? controller;
  TextInputType? textInputType;
  FormFieldValidator<String>? validator;
  bool read;
  Widget? suffix;
  bool mdp;
  Function? onTap;
  // ignore: prefer_typing_uninitialized_variables
  var onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12),
      padding: const EdgeInsets.all(12),
      child: TextFormField(
        onTap: onTap as void Function()?,
        onChanged: onChanged,
        obscureText: mdp,
        readOnly: read,
        controller: controller,
        initialValue: value,
        validator: validator,
        keyboardType: textInputType,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
            color: Colors.black, decoration: TextDecoration.none),
        decoration: InputDecoration(
          suffixIcon: suffix,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w400, color: Colors.blue),
          labelText: label,
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(24)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1),
              borderRadius: BorderRadius.circular(24)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1),
              borderRadius: BorderRadius.circular(24)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(width: 1),
              borderRadius: BorderRadius.circular(24)),
        ),
      ),
    );
  }
}
