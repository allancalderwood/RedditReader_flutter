import 'package:flutter/material.dart';
import './theme.dart';

InputDecoration buildInputDecoration(String hint, bool theme, Icon icon){
  var bgCol;
  if (theme){// if dark theme
    bgCol = currentTheme.primaryColorDark;
  }else{
    bgCol = currentTheme.textTheme.headline1.color;
  }
  return InputDecoration(
    fillColor: bgCol,
    filled: true,
    counterText: "",
    prefixIcon: icon,

    hintStyle: TextStyle(fontSize: 20.0, color: currentTheme.accentColor),
    hintText: hint,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: bgCol)
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: bgCol)
    ),
  );
}

