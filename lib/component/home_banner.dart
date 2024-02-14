import 'package:flutter/material.dart';
import 'package:ypa/util/goal_dialog.dart';
import 'package:ypa/util/string_color.dart';

import 'goal_form.dart';

class HomeBanner extends StatelessWidget {
  final title;
  const HomeBanner({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: stringColor("AEBDCA"),
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 19,
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: GoalForm(),
                    );
                  },
                );
              },
              child: Text(
                String.fromCharCode(Icons.add.codePoint),
                style: TextStyle(
                  inherit: false,
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w800,
                  fontFamily: Icons.add.fontFamily,
                  package: Icons.add.fontPackage,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
