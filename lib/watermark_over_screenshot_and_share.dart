// import 'dart:ffi';
import 'dart:io';
// import 'dart:html';
// import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as ui;

// ignore: must_be_immutable
class WatermarkOverScreenShotAndShare extends StatelessWidget {
  File? _capturedImage;
  File? _watermarkImage;
  Uint8List? _watermarkedImage;
  Uint8List? img;

  File? _getCapturedImgFile;
  File? _getWatermarkImgFile;
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    Future shareIt(Uint8List bytes) async {
      final directory = await getApplicationDocumentsDirectory();
      final image = File('${directory.path}/waterMarked.png');
      image.writeAsBytesSync(bytes);
      final text = 'Download the app!';
      await Share.shareFiles([image.path], text: text);
    }

    Future<String> getFilePath() async {
      await [Permission.storage].request();
      // Directory appDocumentsDirectory =
      //     await getApplicationDocumentsDirectory();
      Directory? appDocumentsDirectory = await getExternalStorageDirectory();
      String appDocumentsPath = appDocumentsDirectory!.path;
      String filePath = '$appDocumentsPath/foodss.png';
      return filePath;
    }

    Future<File> getWatermarkImageFromFilesDirectory() async {
      var myFilePath = await getFilePath();
      _watermarkImage = File(myFilePath);
      return _watermarkImage!;
    }

    Future<Null> saveFile() async {
      // await [Permission.storage].request();
      File file = File(await getFilePath());
      final byteData = await rootBundle.load('assets/images/foodss.png');
      file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }

    Future<File> getCapturedImage(Uint8List bytes) async {
      final directory = await getApplicationDocumentsDirectory();
      _capturedImage = File('${directory.path}/flutter_image.png');
      _capturedImage!.writeAsBytesSync(bytes);
      return _capturedImage!;
    }

    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        backgroundColor: Colors.amberAccent,
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              height: 200,
              color: Colors.pinkAccent,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final ss = await _screenshotController.capture();
                await getFilePath();
                await saveFile();

                if (ss == null) {
                  return;
                }
                _getWatermarkImgFile =
                    await getWatermarkImageFromFilesDirectory();
                _getCapturedImgFile = await getCapturedImage(ss);

                if (_getCapturedImgFile == null ||
                    _getWatermarkImgFile == null) {
                  return;
                }
                ui.Image? originalImage =
                    ui.decodeImage(_getCapturedImgFile!.readAsBytesSync());
                ui.Image? watermarkImage =
                    ui.decodeImage(_getWatermarkImgFile!.readAsBytesSync());

                ui.Image? image = ui.Image(50, 50);
                ui.drawImage(image, watermarkImage!);

                ui.copyInto(originalImage!, image,
                    dstX: originalImage.width - 50 - 25,
                    dstY: originalImage.height - 50 - 25);

                ui.drawString(originalImage, ui.arial_48, 75,
                    originalImage.height - 50 - 25, 'try our app now');

                List<int> wmImage = ui.encodePng(originalImage);

                _watermarkedImage = Uint8List.fromList(wmImage);

                if (_watermarkedImage != null) {
                  await shareIt(_watermarkedImage!);
                }
              },
              child: Text('watermark and share'),
            ),
          ],
        ),
      ),
    );
  }
}
