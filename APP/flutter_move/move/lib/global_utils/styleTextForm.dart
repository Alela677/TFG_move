import 'package:flutter/material.dart';

InputDecoration decoration = const InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 15),
  filled: true,
  fillColor: Colors.white,
  isDense: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(color: Colors.green),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(color: Colors.green),
  ),
);
