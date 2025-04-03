import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:sizer/sizer.dart';

class FormCustomWidget extends StatelessWidget {
  const FormCustomWidget(
      {super.key,
      required this.name,
      required this.obscureText,
      required this.hintText,
      this.validator,
      required this.icon,
      required this.keyboardType});
  final String name;
  final bool obscureText;
  final String hintText;
  final String? Function(String?)? validator;
  final IconData icon;
  final TextInputType keyboardType;
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      name: name,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.deepPurple, fontFamily: 'Roboto'),
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.red, fontSize: 11.sp),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.deepPurple)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.deepPurple)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.deepPurple)),
          suffixIcon: Icon(
            icon,
            color: Colors.deepPurple,
          )),
    );
  }
}
