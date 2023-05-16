import 'package:flutter/material.dart';

class MyListTitleModel extends StatefulWidget {
  final Widget? title;
  final void Function()? onTap;

  const MyListTitleModel({
    Key? key,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  State<MyListTitleModel> createState() => _MyListTitleModelState();
}

class _MyListTitleModelState extends State<MyListTitleModel> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (value) {
        setState(() {
          _isHovering = value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _isHovering ? Colors.grey.shade200 : Colors.transparent,
        ),
        child: ListTile(
          title: widget.title,
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
