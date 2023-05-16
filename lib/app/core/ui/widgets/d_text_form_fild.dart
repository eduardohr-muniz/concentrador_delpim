import 'package:flutter/material.dart';

class DTextFormFild extends StatelessWidget {
  final TextEditingController? controller;
  final Widget label;
  const DTextFormFild({
    Key? key,
    required this.controller,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: label,
      ),
    );
  }
}
