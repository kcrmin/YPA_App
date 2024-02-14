import 'package:flutter/material.dart';

stringColor(String color) {
  return Color(
    int.parse(
      'FF${color}',
      radix: 16,
    ),
  );
}
