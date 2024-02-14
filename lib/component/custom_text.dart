import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final onTextSaved;
  final String title;
  const CustomText({
    required this.onTextSaved,
    required this.title,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return "Enter Something";
        } else {
          return null;
        }
      },
      initialValue: title ?? "Hi",
      onSaved: onTextSaved,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        prefixIcon: Text("   Goal: ", style: TextStyle(
          fontSize: 18.0,
        ),),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        hintStyle: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
