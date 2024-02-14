import 'package:flutter/material.dart';
import 'package:ypa/util/string_color.dart';

class MainLayout extends StatelessWidget {
  final body;
  const MainLayout({
    required this.body,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: stringColor("AEBDCA"),
          centerTitle: true,
          title: IconButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Image.asset(
              'asset/img/YPA_Logo.png',
              scale: 6,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/class', (route) => route.isFirst);
              },
              icon: Icon(
                Icons.people,
                size: 35,

              ),
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
