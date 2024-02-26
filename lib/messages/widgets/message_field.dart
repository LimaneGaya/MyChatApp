import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageField extends StatelessWidget {
  final TextEditingController con;
  final VoidCallback func;
  final bool autofocus;

  const MessageField(
    this.con,
    this.func, {
    super.key,

    /// if focus should be on this widget (showing keyboard as soon as this
    /// widget is built)
    this.autofocus = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 255,
      minLines: 1,
      maxLines: 4,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: con,
      autofocus: autofocus,
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
