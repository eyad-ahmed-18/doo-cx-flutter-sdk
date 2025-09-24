import 'dart:io';
import 'package:doo_cx_flutter_sdk/doo_cx_flutter_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// Import test pages
import 'api_feature_test.dart';
import 'error_handling_test.dart';
import 'performance_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOO CX Flutter SDK Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('DOO CX Flutter SDK Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or image
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/doo_logo.png',
                width: 200,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'DOO CX Flutter SDK',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Choose an integration method below:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            // Integration options
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WebviewWidgetExample(),
                ),
              ),
              child: const Text('Webview Widget Example'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => _showChatDialog(context),
              child: const Text('Chat Dialog Example'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatPageExample(),
                ),
              ),
              child: const Text('Chat Page Example'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomClientExample(),
                ),
              ),
              child: const Text('Custom Client Example'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Advanced Examples & Testing:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ApiFeatureTestPage(),
                ),
              ),
              icon: const Icon(Icons.check_circle),
              label: const Text('API Feature Tests'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ErrorHandlingTestPage(),
                ),
              ),
              icon: const Icon(Icons.bug_report),
              label: const Text('Error Handling Tests'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PerformanceTestPage(),
                ),
              ),
              icon: const Icon(Icons.speed),
              label: const Text('Performance Tests'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChatDialog(BuildContext context) {
    DOOChatDialog.show(
      context,
      baseUrl: "http://localhost:3001", // Your local DOO CX instance
      inboxIdentifier: "9Bj33Z9cWv1o769zBFpvnUSk", // Flutter SDK token from DOO CX inbox 256
      title: "DOO Support",
      user: DOOUser(
        identifier: "flutter_tester",
        name: "Flutter Tester",
        email: "someone@example.com",
      ),
    );
  }
}

class WebviewWidgetExample extends StatelessWidget {
  const WebviewWidgetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Webview Widget Example'),
      ),
      body: DOOWidget(
        websiteToken: "9Bj33Z9cWv1o769zBFpvnUSk", // Flutter SDK token from DOO CX inbox 256
        baseUrl: "http://localhost:3001", // Your local DOO CX instance
        user: DOOUser(
          identifier: "flutter_tester",
          name: "Flutter Tester",
          email: "someone@example.com",
        ),
        locale: "en",
        closeWidget: () => Navigator.pop(context),
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
    if (decodedImage == null) return [];
    
    final scaledImage = image.copyResize(decodedImage, width: 500);
    final jpg = image.encodeJpg(scaledImage, quality: 90);

    final filePath = (await getTemporaryDirectory()).uri.resolve(
          './image_${DateTime.now().microsecondsSinceEpoch}.jpg',
        );
    final file = await File.fromUri(filePath).create(recursive: true);
    await file.writeAsBytes(jpg, flush: true);

    return [file.uri.toString()];
  }
}

class ChatPageExample extends StatelessWidget {
  const ChatPageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DOOChat(
      baseUrl: "http://localhost:3001", // Your local DOO CX instance
      inboxIdentifier: "9Bj33Z9cWv1o769zBFpvnUSk", // Flutter SDK token from DOO CX inbox 256
      user: DOOUser(
        identifier: "flutter_tester",
        name: "Flutter Tester",
        email: "someone@example.com",
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Chat Page Example'),
      ),
    );
  }
}

class CustomClientExample extends StatefulWidget {
  const CustomClientExample({super.key});

  @override
  State<CustomClientExample> createState() => _CustomClientExampleState();
}

class _CustomClientExampleState extends State<CustomClientExample> {
  DOOClient? _client;
  List<DOOMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = true;
  String _statusMessage = "Initializing...";

  @override
  void initState() {
    super.initState();
    _initDOOClient();
  }

  Future<void> _initDOOClient() async {
    setState(() {
      _statusMessage = "Connecting to DOO CX...";
    });

    final dooCallbacks = DOOCallbacks(
      onWelcome: () {
        if (mounted) {
          setState(() {
            _statusMessage = "Connected to DOO CX";
          });
        }
      },
      onPersistedMessagesRetrieved: (persistedMessages) {
        if (mounted) {
          setState(() {
            _messages = persistedMessages;
          });
        }
      },
      onMessagesRetrieved: (messages) {
        if (mounted) {
          setState(() {
            _messages = messages;
            _isLoading = false;
          });
        }
      },
      onMessageReceived: (message) {
        if (mounted) {
          setState(() {
            _messages.add(message);
          });
        }
      },
      onMessageSent: (message, echoId) {
        if (kDebugMode) {
          print("Message sent with ID: $echoId");
        }
        // Replace optimistic message with the real one from server
        if (mounted) {
          setState(() {
            // Find and remove the optimistic message (negative ID) with the same content
            _messages.removeWhere((msg) => 
              msg.content == message.content && 
              msg.id < 0);
            
            // Add the real message from server (avoid duplicates)
            final realMessageExists = _messages.any((msg) => msg.id == message.id);
            if (!realMessageExists) {
              _messages.add(message);
            }
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _statusMessage = "Error: ${error.cause}";
            _isLoading = false;
          });
        }
      },
    );

    try {
      _client = await DOOClient.create(
        baseUrl: "http://localhost:3001", // Your local DOO CX instance
        inboxIdentifier: "9Bj33Z9cWv1o769zBFpvnUSk", // Flutter SDK token from DOO CX inbox 256
        user: DOOUser(
          identifier: "flutter_tester",
          name: "Flutter Tester",
          email: "someone@example.com",
        ),
        callbacks: dooCallbacks,
      );
      
      await _client!.loadMessages();
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = "Failed to initialize DOO client: $e";
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_textController.text.isNotEmpty && _client != null) {
      final content = _textController.text;
      _textController.clear();
      
      try {
        // Create optimistic message immediately for better UX
        final optimisticId = -DateTime.now().millisecondsSinceEpoch; // Negative ID for optimistic messages
        final optimisticMessage = DOOMessage(
          id: optimisticId,
          content: content,
          messageType: 0, // outgoing message type
          contentType: "text",
          contentAttributes: {},
          createdAt: DateTime.now().toIso8601String(),
          conversationId: 0,
          attachments: [],
          sender: null,
        );
        
        // Add to UI immediately
        setState(() {
          _messages.add(optimisticMessage);
        });
        
        final echoId = await _client!.sendMessage(content: content);
        if (kDebugMode) {
          print("Message sent with echo ID: $echoId");
        }
      } catch (e) {
        if (kDebugMode) {
          print("Failed to send message: $e");
        }
        // Remove optimistic message on failure
        setState(() {
          _messages.removeWhere((msg) => msg.content == content && msg.id < 0);
        });
      }
    }
  }

  @override
  void dispose() {
    _client?.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Custom Client Example'),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(_statusMessage),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: _messages.isEmpty
                      ? const Center(child: Text('No messages yet'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            final isUser = message.isMine;
                            
                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 8.0,
                                ),
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Text(
                                  message.content ?? '',
                                  style: TextStyle(
                                    color: isUser
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
