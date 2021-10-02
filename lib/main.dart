import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

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
      home: MyScreen(),
    );
  }
}

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
                    // await saveImage(image);
                    await saveAndShare(image);
                    print('saveAndShare done');
                  }
                },
                child: Text('capture and share')),
          ],
        ),
      ),
    );
  }

  // Future<String> saveImage(Uint8List bytes) async {
  //   await [Permission.storage].request();

  //   final time = DateTime.now();
  //   final name = 'screenshot_$time';
  //   final result = await ImageGallerySaver.saveImage(bytes, name: name);
  //   return result['filePath'];
  // }

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

// class MyScreen extends StatelessWidget {
//   ScreenshotController screenshotController = ScreenshotController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Screenshot(
//             controller: screenshotController,
//             child: Container(
//               height: 400,
//               color: Colors.green,
//               child: Column(
//                 children: [
//                   Container(
//                       padding: const EdgeInsets.all(30.0),
//                       decoration: BoxDecoration(
//                         border:
//                             Border.all(color: Colors.blueAccent, width: 5.0),
//                         color: Colors.amberAccent,
//                       ),
//                       child: Text("some widget")),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 25,
//           ),
//           ElevatedButton(
//             child: Text(
//               'Capture Above Widget',
//             ),
//             onPressed: () {
//               screenshotController
//                   .capture(delay: Duration(milliseconds: 10))
//                   .then((capturedImage) async {
//                 ShowCapturedWidget(context, capturedImage!);
//               }).catchError((onError) {
//                 print(onError);
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future<dynamic> ShowCapturedWidget(
//       BuildContext context, Uint8List capturedImage) {
//     return showDialog(
//       useSafeArea: false,
//       context: context,
//       builder: (context) => Scaffold(
//           appBar: AppBar(
//             title: Text("Captured widget screenshot"),
//           ),
//           body: Column(
//             children: [
//               Center(
//                   child: capturedImage != null
//                       ? Image.memory(capturedImage)
//                       : Container()),
//               ElevatedButton(
//                   onPressed: () {
//                     print('sharing ');
//                   },
//                   child: Text('share'))
//             ],
//           )),
//     );
//   }
// }
