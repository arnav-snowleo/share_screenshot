import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';

class MyScreen extends StatelessWidget {
  final ScreenshotController _screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            buildImage(),
            const SizedBox(height: 32),
            ElevatedButton(
                onPressed: () async {
                  final image = await _screenshotController.capture();

                  if (image == null) {
                    print('failed to capture');
                  } else {
                    await saveAndShare(image);
                  }
                },
                child: Text('capture and share')),
          ],
        ),
      ),
    );
  }

  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();

    final time = DateTime.now();
    final image = File('${directory.path}/_${time}_flutter.png');
    image.writeAsBytesSync(bytes);

    final text = 'Download DUNO!';
    await Share.shareFiles([image.path], text: text);
  }

  Widget buildImage() {
    return Container(
      height: 500,
      width: 400,
      child: Image.network(
        'https://images.unsplash.com/photo-1632952297232-0548107fdab3?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=389&q=80',
        fit: BoxFit.cover,
      ),
    );
  }
}
