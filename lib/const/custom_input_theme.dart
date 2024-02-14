import 'package:flutter/material.dart';

class CustomInputTheme {
  TextStyle _builtTextStyle(Color color, {double size = 16.0}){
    return TextStyle(
      color: color,
      fontSize: size,
    );
  }

  OutlineInputBorder _buildBorder(Color color){
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: color,
        width: 0.5,
      ),
    );
  }

  InputDecorationTheme theme() => InputDecorationTheme(
    contentPadding: EdgeInsets.all(8),
    // isDense seems to do nothing if you pass padding in
    isDense: true,
    // "always" put the label at the top
    floatingLabelBehavior: FloatingLabelBehavior.always,
    //This can be useful for putting TextFields in a row.
    // However, it might be more desirable to wrap with Flexible
    // to make them to the available width.
    // constraints: BoxConstraints(maxWidth: 150),  // <== Unlock this
    // enable background color
    filled: true,
    fillColor: Color(0xFFF5EFE6),

    /// Borders
    // Enabled and not showing error
    enabledBorder: _buildBorder(Colors.grey[600]!),
    // Has error but not focus
    errorBorder: _buildBorder(Colors.red),
    // Has error and focus
    focusedErrorBorder: _buildBorder(Colors.red),
    // Enabled and focused
    focusedBorder: _buildBorder(Colors.blue),
    // Disabled
    disabledBorder: _buildBorder(Colors.grey[400]!),

    /// TextStyles
    suffixStyle: _builtTextStyle(Colors.black),
    counterStyle: _builtTextStyle(Colors.grey, size: 12.0),
    floatingLabelStyle: _builtTextStyle(Colors.black),
    // Make error and helper the same size, so that the field
    // does not grow in height when there is an error text
    errorStyle: _builtTextStyle(Colors.red, size: 12.0),
    helperStyle: _builtTextStyle(Colors.black, size:12.0),
    hintStyle: _builtTextStyle(Colors.grey),
    labelStyle: _builtTextStyle(Colors.black),
    prefixStyle: _builtTextStyle(Colors.black),
  );
}