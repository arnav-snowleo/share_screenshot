import 'package:flutter/material.dart';

import './new_watermark_screen.dart';
import './asset_screen.dart';
import './my_screen.dart';
import './watermark_screen.dart';

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
      // home: MyWatermarkScreen(),
      home: NewWatermarkScreen(),
      // home: AssetScreen(),
    );
  }
}


//flutter run --no-sound-null-safety