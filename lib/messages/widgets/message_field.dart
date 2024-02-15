import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageField extends StatelessWidget {
  final TextEditingController con;
  final VoidCallback func;

  const MessageField(this.con, this.func, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 255,
      minLines: 1,
      maxLines: 4,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: con,
      autofocus: true,
      onEditingComplete: func,
      decoration: InputDecoration(
          counterText: '',
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(width: 5))),
    );
  }
}
