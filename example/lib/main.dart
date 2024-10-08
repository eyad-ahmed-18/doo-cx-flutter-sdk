import 'dart:io';
import 'package:doo_cx_flutter_sdk/doo_cx_flutter_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOO CX Flutter SDK Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'DOO CX Flutter SDK Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: DOOWidget(
        websiteToken: "your_website_token",
        baseUrl: "https://cx.doo.ooo",
        user: DOOUser(
          identifier: "flutter_tester",
          name: "Flutter Tester",
          email: "someone@example.com",
        ),
        locale: "en",
        closeWidget: _handleCloseWidget,
        onAttachFile: _handleAttachFile,
        onLoadStarted: () {
          if (kDebugMode) {
            print("Loading Widget");
          }
        },
        onLoadProgress: (int progress) {
          if (kDebugMode) {
            print("Loading... $progress");
          }
        },
        onLoadCompleted: () {
          if (kDebugMode) {
            print("Widget Loaded");
          }
        },
      ),
    );
  }

  void _handleCloseWidget() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  Future<List<String>> _handleAttachFile() async {
    return _mobileFilePicker();
  }

  Future<List<String>> _mobileFilePicker() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo == null) {
      return [];
    }

    final imageData = await photo.readAsBytes();
    final decodedImage = image.decodeImage(imageData);
    final scaledImage = image.copyResize(decodedImage!, width: 500);
    final jpg = image.encodeJpg(scaledImage, quality: 90);

    final filePath = (await getTemporaryDirectory()).uri.resolve(
          './image_${DateTime.now().microsecondsSinceEpoch}.jpg',
        );
    final file = await File.fromUri(filePath).create(recursive: true);
    await file.writeAsBytes(jpg, flush: true);

    return [file.uri.toString()];
  }
}
