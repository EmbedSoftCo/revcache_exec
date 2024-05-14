import 'package:flutter/material.dart';

Step createStep(String title, String hintText, TextEditingController textctrl,
    String invalidMessage) {
  return Step(
      title: Text(title),
      content: TextFormField(
        controller: textctrl,
        decoration: InputDecoration(hintText: hintText),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return invalidMessage;
          }
          return null;
        },
      ));
}
