import 'package:flutter/material.dart';
import 'package:share_screenshot/watermark_over_screenshot_and_share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'share ss',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WatermarkOverScreenShotAndShare(),
    );
  }
}
