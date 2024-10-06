[![Pub Version](https://img.shields.io/pub/v/doo_cx_flutter_sdk?color=blueviolet)](https://pub.dev/packages/doo_cx_flutter_sdk)

# DOO CX Flutter SDK

A package to integrate DOO CX into your Flutter mobile application for different platforms. [DOO CX](https://www.doo.ooo) helps businesses automate routine tasks, optimize sales and customer service processes, and provide personalized interactions by seamlessly integrating AI with existing tools and workflows.

## 1. Add the package to your project

Run the command below in your terminal:

`flutter pub add doo_cx_flutter_sdk`

or

Add it manually into your project's [pubspec.yml](https://flutter.dev/docs/development/tools/pubspec) file as the following:
```
dependencies:
  flutter:
    sdk: flutter

  doo_cx_flutter_sdk:
    git:
      url: https://github.com/doo-inc/doo-cx-flutter-sdk.git
```

## 2. Consume the SDK

### a. Using DOOWidget

* Create a website channel in DOO dashboard.
* Replace websiteToken prop in the 'main.dart' file as the following:

```dart
import 'dart:io';
import 'package:doo_cx_flutter_sdk/doo_cx_flutter_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
        websiteToken: "websiteToken",
        baseUrl: "https://cx.doo.ooo",
        user: DOOUser(
          identifier: "flutter_tester",
          name: "Flutter Tester",
          email: "someone@example.com",
        ),
        locale: "en",
        closeWidget: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        },
        //attachment only works on Android for now
        onAttachFile: _androidFilePicker,
        onLoadStarted: () {
          if (kDebugMode) {
            print("loading widget");
          }
        },
        onLoadProgress: (int progress) {
          if (kDebugMode) {
            print("loading... $progress");
          }
        },
        onLoadCompleted: () {
          if (kDebugMode) {
            print("widget loaded");
          }
        },
      ),
    );
  }

  Future<List<String>> _androidFilePicker() async {
    final picker = image_picker.ImagePicker();
    final photo =
        await picker.pickImage(source: image_picker.ImageSource.gallery);

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
```

#### Available Parameters

| Name             | Default | Type                            | Description                                                                                            |
|------------------|---------|---------------------------------|--------------------------------------------------------------------------------------------------------|
| websiteToken     | -       | String                          | Website inbox channel token                                                                            |
| baseUrl          | -       | String                          | Installation url for DOO                                                                          |
| user             | -       | DOOUser                    | User information about the user like email, username and avatar_url                                    |
| locale           | en      | String                          | User locale                                                                                            |
| closeWidget      | -       | void Function()                 | widget close event                                                                                     |
| customAttributes | -       | dynamic                         | Additional information about the customer                                                              |
| onAttachFile     | -       | Future<List<String>> Function() | Widget Attachment event. Should return a list of File Uris Currently supported only on Android devices |
| onLoadStarted    | -       | void Function()                 | Widget load start event                                                                                |
| onLoadProgress   | -       | void Function(int)              | Widget Load progress event                                                                             |
| onLoadCompleted  | -       | void Function()                 | Widget Load completed event                                                                            |

### b. Using DOOClient
* Create an API inbox in DOO dashboard.
* Create your own customized chat UI like the following example and use `DOOClient` to load and sendMessages. Messaging events like `onMessageSent` and `onMessageReceived` will be triggered on `DOOCallback` argument passed when creating the client instance.

Notice: DOO client uses [Hive](https://pub.dev/packages/hive) for local storage.

```dart
final dooCallbacks = DOOCallbacks(
      onWelcome: (){
        print("Welcome");
      },
      onPing: (){
        print("Ping");
      },
      onConfirmedSubscription: (){
        print("Confirmed subscription");
      },
      onConversationStartedTyping: (){
        print("Conversation started typing");
      },
      onConversationStoppedTyping: (){
        print("Conversation stopped typing");
      },
      onPersistedMessagesRetrieved: (persistedMessages){
        print("Persisted messages retrieved");
      },
      onMessagesRetrieved: (messages){
        print("Messages retrieved");
      },
      onMessageReceived: (dooMessage){
        print("Message received");
      },
      onMessageDelivered: (dooMessage, echoId){
        print("Message delivered");
      },
      onMessageSent: (dooMessage, echoId){
        print("Message sent");
      },
      onError: (error){
        print("Sorry! Something went wrong. Error: ${error.cause}");
      },
    );

    DOOClient.create(
        baseUrl: widget.baseUrl,
        inboxIdentifier: widget.inboxIdentifier,
        user: widget.user,
        enablePersistence: widget.enablePersistence,
        callbacks: dooCallbacks
    ).then((client) {
        client.loadMessages();
    }).onError((error, stackTrace) {
      print("DOO client creation failed with error $error: $stackTrace");
    });
```

#### Available Parameters

| Name              | Default | Type              | Description                                                                                                                                                                                                                                                                                                                                                                                                                                        |
|-------------------|---------|-------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| baseUrl           | -       | String            | Installation url for DOO                                                                                                                                                                                                                                                                                                                                                                                                                      |
| inboxIdentifier   | -       | String            | Identifier for target DOO inbox                                                                                                                                                                                                                                                                                                                                                                                                               |
| enablePersistance | true    | bool              | Enables persistence of DOO client instance's contact, conversation and messages to disk <br>for convenience.<br>true - persists DOO client instance's data(contact, conversation and messages) to disk. To clear persisted <br>data call DOOClient.clearData or DOOClient.clearAllData<br>false - holds DOO client instance's data in memory and is cleared as<br>soon as DOO client instance is disposed<br>Setting |
| user              | null    | DOOUser      | Custom user details to be attached to DOO contact                                                                                                                                                                                                                                                                                                                                                                                             |
| callbacks         | null    | DOOCallbacks | Callbacks for handling DOO events                                                                                                                                                                                                                                                                                                                                                                                                             |

