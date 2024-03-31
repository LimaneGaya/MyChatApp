import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController con;
  final bool isHidden;
  final String hintText;
  final Icon? icon;
  final int? length;
  final bool isNumber;
  final String? Function(String?) verify;

  const AuthTextField({
    super.key,
    required this.con,
    this.isHidden = false,
    this.icon,
    required this.hintText,
    this.length,
    this.isNumber = false,
    required this.verify,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool isObscured = false;
  @override
  void initState() {
    super.initState();
    isObscured = widget.isHidden;
  }

  @override
  void dispose() {
    widget.con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.isNumber ? TextInputType.number : null,
      controller: widget.con,
      obscureText: isObscured,
      maxLength: widget.length,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      decoration: inputDecoration(context),
      validator: widget.verify,
    );
  }

  final bRadius = BorderRadius.circular(8);
  InputDecoration inputDecoration(BuildContext context) => InputDecoration(
        contentPadding: const EdgeInsets.all(25),
        counterText: '',
        enabledBorder: OutlineInputBorder(
          borderRadius: bRadius,
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: bRadius,
          borderSide: BorderSide(
            width: 3,
            color: Theme.of(context).colorScheme.primary,
          ),
          gapPadding: 10,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: bRadius,
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.error,
          ),
          gapPadding: 10,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: bRadius,
          borderSide: BorderSide(
            width: 3,
            color: Theme.of(context).colorScheme.error,
          ),
          gapPadding: 10,
        ),
        suffixIcon: widget.isHidden
            ? IconButton(
                onPressed: () => setState(() => isObscured = !isObscured),
                icon: Icon(
                    !isObscured ? Icons.close_rounded : Icons.remove_red_eye),
              )
            : null,
        hintText: widget.hintText,
        icon: widget.icon,
      );
}
