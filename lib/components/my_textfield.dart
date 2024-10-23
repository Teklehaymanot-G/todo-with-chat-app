import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String labelText, hintText;
  final bool obscureText;
  final TextEditingController controller;
  const MyTextField({super.key, this.labelText = "", this.hintText = "", this.obscureText = false, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.tertiary)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary)),
            fillColor: Theme.of(context).colorScheme.tertiary,
            filled: true,
            labelText: labelText,
            hintText: hintText,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary)
          ),
          obscureText: obscureText,
        ));
  }
}
