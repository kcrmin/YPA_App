import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ypa/layout/main_layout.dart';

final Uri classUri = Uri.parse("https://portal.psb-academy.edu.sg/OnlineCourseDisplay/default.aspx");

class ClassroomScreen extends StatelessWidget {
  WebViewController wvController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(classUri);
  ClassroomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(body: WebViewWidget(controller: wvController));
  }
}

