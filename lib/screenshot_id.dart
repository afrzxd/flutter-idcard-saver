import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ScreenshotPage extends StatefulWidget {
  const ScreenshotPage({super.key});

  @override
  State<ScreenshotPage> createState() => _ScreenshotPageState();
}

class _ScreenshotPageState extends State<ScreenshotPage> {
  final controller = ScreenshotController();
  @override
  Widget build(BuildContext context) => Screenshot(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ID CARD'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildImage(),
              ),
              SizedBox(
                height: 10,
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     await controller.capture().then(
              //       (bytes) {
              //         if (bytes != null) {
              //           saveImage(bytes);
              //           saveAndShare(bytes);
              //         }
              //       },
              //     ).catchError(
              //       (onError) {
              //         debugPrint(onError);
              //       },
              //     );
              //   },
              //   child: const Text('Take Screenshot'),
              // ),
              ElevatedButton(
                  onPressed: () async {
                    await controller.captureFromWidget(buildImage()).then(
                      (bytes) {
                        saveImage(bytes);
                        saveAndShare(bytes);
                      },
                    ).catchError(
                      (onError) {
                        debugPrint(onError);
                      },
                    );
                  },
                  child: const Text('Save ID Card'))
            ],
          ),
        ),
      ));
}

final time =
    DateTime.now().toIso8601String().replaceAll('.', '-').replaceAll(':', '-');

Future<void> saveAndShare(Uint8List bytes) async {
  final directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationDocumentsDirectory();
  final image = File('${directory!.path}/$time.png');
  image.writeAsBytes(bytes);
  await Share.shareXFiles([XFile(image.path)]);
}

Future<void> saveImage(Uint8List bytes) async {
  final name = 'screenshot_$time';
  await Permission.storage.request();
  final result = await ImageGallerySaver.saveImage(bytes, name: name);
  debugPrint('result: $result');
}

Widget buildImage() => Container(
      color: Colors.blue,
      alignment: Alignment.center,
      width: 850,
      height: 539,
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 15),
          child: Column(
            children: [
              const FlutterLogo(
                size: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'PT Acc Indonesia',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(8.0),
                child: Image.asset(
                  'data/sample_foto.png',
                  width: 200,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                '20293720171',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'Agus Putri',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'Manager',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
