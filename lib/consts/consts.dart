import 'package:flutter/material.dart';

List<Shadow> getShadows(BuildContext context) {
  final theme = Theme.of(context).brightness;
  if (theme == Brightness.dark) {
    return const [BoxShadow(blurRadius: 5, color: Colors.black)];
  } else {
    return const [BoxShadow(blurRadius: 5, color: Colors.white)];
  }
}
