// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ButtonHeader extends StatelessWidget {
  final String text;
  final bool selected;
  final void Function()? onTap;

  const ButtonHeader({
    Key? key,
    required this.text,
    this.onTap,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: selected ? Colors.white.withAlpha(80) : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Text(text,
                style: TextStyle(
                  color: selected ? Colors.black : Colors.white,
                )),
          ),
        ),
      ),
    );
  }
}
