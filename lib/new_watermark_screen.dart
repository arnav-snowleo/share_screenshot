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

class NewWatermarkScreen extends StatefulWidget {
  @override
  _NewWatermarkScreenState createState() => _NewWatermarkScreenState();
}

class _NewWatermarkScreenState extends State<NewWatermarkScreen> {
  @override
  File? _capturedImage;
  File? _watermarkImage;
  Uint8List? _watermarkedImage;
  // File? _watermarkedImage;
  Uint8List? img;

  File? _getCapturedImgFile;
  File? _getWatermarkImgFile;

  File? gotCaptured;
  File? gotAppIcon;

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
      // Directory appDocumentsDirectory =
      //     await getApplicationDocumentsDirectory(); // 1
      Directory? appDocumentsDirectory =
          await getExternalStorageDirectory(); // 1
      String appDocumentsPath = appDocumentsDirectory!.path; // 2
      String filePath = '$appDocumentsPath/foodss.png'; // 3
      return filePath;
    }

    Future<File> getWatermarkImageFromFilesDirectory() async {
      var myFilePath = await getFilePath();
      _watermarkImage = File(myFilePath);
      return _watermarkImage!;
    }

    void saveFile() async {
      await [Permission.storage].request();

      File file = File(await getFilePath()); // 1
      final byteData = await rootBundle.load('assets/images/foodss.png');
      file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)); // 2
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
                final image = await _screenshotController.capture();

                if (image == null) {
                  print('failed to capture');
                } else {
                  setState(() {
                    img = image;
                  });
                  print('captured');
                  // await saveAndShare(image);
                }
                await getFilePath();
                saveFile();
              },
              child: Text('capture, add icon to app dir'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (img == null) {
                  print('returned');
                  return;
                }
                _getWatermarkImgFile =
                    await getWatermarkImageFromFilesDirectory();

                setState(() {
                  gotAppIcon = _getWatermarkImgFile;
                });
                print('watermark img got and setstate');
                _getCapturedImgFile = await getCapturedImage(img!);
                setState(() {
                  gotCaptured = _getCapturedImgFile;
                });
                print('captured img got and setstate');

                if (gotCaptured == null || gotAppIcon == null) {
                  return;
                }
                //start watermark process
                ui.Image? originalImage =
                    ui.decodeImage(gotCaptured!.readAsBytesSync());
                ui.Image? watermarkImage =
                    ui.decodeImage(gotAppIcon!.readAsBytesSync());

                // add watermark over originalImage
                // initialize width and height of watermark image
                ui.Image? image = ui.Image(50, 50);
                ui.drawImage(image, watermarkImage!);

                // give position to watermark over image
                ui.copyInto(originalImage!, image,
                    dstX: originalImage.width - 50 - 25,
                    dstY: originalImage.height - 50 - 25);

                // for adding text over image (x,y)
                ui.drawString(originalImage, ui.arial_48, 75,
                    originalImage.height - 50 - 25, 'try our app now');

                // Store the watermarked image to a File
                List<int> wmImage = ui.encodePng(originalImage);
                setState(() {
                  _watermarkedImage = Uint8List.fromList(wmImage);
                });
                if (_watermarkedImage != null) {
                  await shareIt(_watermarkedImage!);
                }
                //end
              },
              child: Text('watermark and share'),
            ),
          ],
        ),
      ),
    );
  }
}

// Skipped 111 frames!  The application may be doing too much work on its main thread.
//error-> Unhandled Exception: Null check operator used on a null value
//ref->
//https://stackoverflow.com/questions/64278595/null-check-operator-used-on-a-null-value

// good read for image processing
// https://github.com/brendan-duncan/image/wiki/Examples
