import 'package:flutter/material.dart';
import './theme.dart';

InputDecoration buildInputDecoration(String hint){
  return InputDecoration(
    fillColor: currentTheme.textTheme.headline1.color,
    filled: true,
    counterText: "",
    hintStyle: TextStyle(fontSize: 20.0, color: currentTheme.accentColor),
    hintText: hint,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: currentTheme.accentColor)
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: currentTheme.accentColor)
    ),
  );
}

