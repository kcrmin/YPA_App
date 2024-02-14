import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:ypa/util/goal_dialog.dart';
import 'package:ypa/util/string_color.dart';

class Banners extends StatelessWidget {
  final title;
  const Banners({
    required this.title,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: stringColor("AEBDCA"),
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 19,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
