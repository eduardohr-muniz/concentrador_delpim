import 'package:flutter/material.dart';

class CwTextFild extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  const CwTextFild({
    Key? key,
    required this.controller,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
