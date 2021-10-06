import 'dart:ffi';
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

class MyWatermarkScreen extends StatefulWidget {
  @override
  _MyWatermarkScreenState createState() => _MyWatermarkScreenState();
}

class _MyWatermarkScreenState extends State<MyWatermarkScreen> {
  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    File _capturedImage;
    File _watermarkImage;
    File? _watermarkedImage;

    Future saveAndShare(Uint8List bytes) async {
      final directory = await getApplicationDocumentsDirectory();

      final image = File('${directory.path}/flutter.png');
      image.writeAsBytesSync(bytes);

      final text = 'Download DUNO!';
      await Share.shareFiles([image.path], text: text);
    }

    Widget buildImage() {
      return Container(
        height: 300,
        width: 400,
        child: Image.network(
          'https://images.unsplash.com/photo-1632952297232-0548107fdab3?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=389&q=80',
          fit: BoxFit.cover,
        ),
      );
    }

    /*
    error->
     FileSystemException: Cannot open file, 
     path = '/data/user/0/com.example.share_screenshot/cache/images/food.png'
    */

    //resolve -> https://stackoverflow.com/questions/50119676/how-to-write-a-bytedata-instance-to-a-file-in-dart
    Future<File> getWatermarkImageFileFromAssets(String path) async {
      final byteData = await rootBundle.load('assets/$path');

      _watermarkImage =
          File('${(await getApplicationDocumentsDirectory()).path}/$path');

      await _watermarkImage.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      return _watermarkImage;
    }

    /*
    Future<File> getWatermarkImageFileFromAssets() async {
      final byteData = await rootBundle.load('assets/images/food.png');

      _watermarkImage =
          File('${(await getTemporaryDirectory()).path}/images/food.png');

      await _watermarkImage.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      return _watermarkImage;
    }
    */

    //use it as
    //File f = await getWatermarkImageFileFromAssets();

    // Future _createFolder() async {
    //   await [Permission.storage].request();
    //   print('permission got');

    //   final folderName = "share_ss_asset_image_folder";
    //   print('a');
    //   final path = Directory("/storage/emulated/0/$folderName");
    //   print('b');
    //   if ((await path.exists())) {
    //     // TODO:
    //     print("exist");
    //   } else {
    //     // TODO:
    //     print("not exist");
    //     await path.create();
    //     print("path created");

    //     final byteData = await rootBundle.load('assets/images/food.png');
    //     print('bytedata done');
    //     _watermarkImage = File('$path');
    //     var putAssetInPhone = await _watermarkImage.writeAsBytes(byteData.buffer
    //         .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    //     print('written asset image inside folder');
    //   }
    // }
    Future<String> getFilePath() async {
      // Directory appDocumentsDirectory =
      //     await getApplicationDocumentsDirectory(); // 1
      Directory? appDocumentsDirectory =
          await getExternalStorageDirectory(); // 1
      String appDocumentsPath = appDocumentsDirectory!.path; // 2
      String filePath = '$appDocumentsPath/demoTextFile.txt'; // 3

      return filePath;
    }

    void saveFile() async {
      print('permission req');
      await [Permission.storage].request();
      print('permission got');
      print(await getFilePath());
      File file = File(await getFilePath()); // 1
      file.writeAsString(
          "This is my demo text that will be saved to : demoTextFile.txt"); // 2
    }

    void readFile() async {
      File file = File(await getFilePath()); // 1
      String fileContent = await file.readAsString(); // 2

      print('File Content: $fileContent');
    }

    Future<File> getCapturedImage(Uint8List bytes) async {
      final directory = await getApplicationDocumentsDirectory();
      _capturedImage = File('${directory.path}/flutter_image.png');
      return _capturedImage;
    }

    File _getCapturedImgFile;
    File _getWatermarkImgFile;

    AssetImage waterimg = AssetImage('assets/images/food.png');

    // File tempWaterimgFile = File('assets/images/food.png');

    Uint8List? img;
    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            //  buildImage(),
            const SizedBox(height: 32),
            // ElevatedButton(
            //   onPressed: () async {
            //     final image = await _screenshotController.capture();

            //     if (image == null) {
            //       print('failed to capture');
            //     } else {
            //       setState(() {
            //         img = image;
            //       });
            //       print('captured');
            //       // await saveAndShare(image);
            //     }
            //   },
            //   child: Text('capture and share'),
            // ),
            ElevatedButton(
              onPressed: () async {
                await getFilePath();
                saveFile();
                readFile();
              },
              child: Text('create directory and add asset image'),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     _getWatermarkImgFile = tempWaterimgFile;
            //     // _getWatermarkImgFile =
            //     //     await getWatermarkImageFileFromAssets('images/food.png');
            //     print('watermark img got');
            //     _getCapturedImgFile = await getCapturedImage(img!);
            //     print('captured img got');

            //     //start watermark process
            //     ui.Image? originalImage =
            //         ui.decodeImage(_getCapturedImgFile.readAsBytesSync());
            //     ui.Image? watermarkImage =
            //         ui.decodeImage(_getWatermarkImgFile.readAsBytesSync());

            //     // add watermark over originalImage
            //     // initialize width and height of watermark image
            //     ui.Image image = ui.Image(160, 50);
            //     ui.drawImage(image, watermarkImage!);

            //     // give position to watermark over image
            //     // originalImage.width - 160 - 25 (width of originalImage - width of watermarkImage - extra margin you want to give)
            //     // originalImage.height - 50 - 25 (height of originalImage - height of watermarkImage - extra margin you want to give)
            //     ui.copyInto(originalImage!, image,
            //         dstX: originalImage.width - 160 - 25,
            //         dstY: originalImage.height - 50 - 25);

            //     // for adding text over image
            //     // Draw some text using 24pt arial font
            //     // 100 is position from x-axis, 120 is position from y-axis
            //     ui.drawString(
            //         originalImage, ui.arial_24, 100, 120, 'Think Different');

            //     // Store the watermarked image to a File
            //     List<int> wmImage = ui.encodePng(originalImage);
            //     setState(() {
            //       _watermarkedImage =
            //           File.fromRawPath(Uint8List.fromList(wmImage));
            //     });

            //     //end
            //   },
            //   child: Text('process image'),
            // ),
            // _watermarkedImage != null
            //     ? Image.file(_watermarkedImage!)
            //     : Container(),
          ],
        ),
      ),
    );
  }
}



// Center(
//           child: Column(
//             children: <Widget>[
// //<--------------- select original image ---------------->
//               _originalImage == null
//                   ? ElevatedButton(
//                       child: Text("Select Original Image"),
//                       onPressed: getOriginalImage,
//                     )
//                   : Container(
//                       height: 100,
//                       width: 20,
//                       child: Image.file(_originalImage!)),

// //<--------------- select watermark image ---------------->
//               _watermarkImage == null
//                   ? ElevatedButton(
//                       child: Text("Select Watermark Image"),
//                       onPressed: getWatermarkImage,
//                     )
//                   : Image.file(_watermarkImage!),

//               SizedBox(
//                 height: 50,
//               ),
// //<--------------- apply watermark over image ---------------->
//               (_originalImage != null) && (_watermarkImage != null)
//                   ? ElevatedButton(
//                       child: Text("Apply Watermark Over Image"),
//                       onPressed: () async {
//                         ui.Image? originalImage =
//                             ui.decodeImage(_originalImage!.readAsBytesSync());
//                         ui.Image? watermarkImage =
//                             ui.decodeImage(_watermarkImage!.readAsBytesSync());

//                         // add watermark over originalImage
//                         // initialize width and height of watermark image
//                         ui.Image image = ui.Image(160, 50);
//                         ui.drawImage(image, watermarkImage!);

//                         // give position to watermark over image
//                         // originalImage.width - 160 - 25 (width of originalImage - width of watermarkImage - extra margin you want to give)
//                         // originalImage.height - 50 - 25 (height of originalImage - height of watermarkImage - extra margin you want to give)
//                         ui.copyInto(originalImage!, image,
//                             dstX: originalImage.width - 160 - 25,
//                             dstY: originalImage.height - 50 - 25);

//                         // for adding text over image
//                         // Draw some text using 24pt arial font
//                         // 100 is position from x-axis, 120 is position from y-axis
//                         ui.drawString(originalImage, ui.arial_24, 100, 120,
//                             'Think Different');

//                         // Store the watermarked image to a File
//                         List<int> wmImage = ui.encodePng(originalImage);
//                         setState(() {
//                           _watermarkedImage =
//                               File.fromRawPath(Uint8List.fromList(wmImage));
//                         });
//                       },
//                     )
//                   : Container(),

// //<--------------- display watermarked image ---------------->
//               _watermarkedImage != null
//                   ? Image.file(_watermarkedImage!)
//                   : Container(),
//             ],
//           ),
//         ),
