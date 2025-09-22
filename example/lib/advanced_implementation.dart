import 'package:flutter/material.dart';
import 'package:doo_cx_flutter_sdk/doo_cx_flutter_sdk.dart';

/// Comprehensive example demonstrating all DOO CX customization features
/// 
/// This example shows:
/// - Custom themes and styling
/// - Localization and internationalization
/// - Advanced callbacks and event handling
/// - Error handling and user feedback
/// - File attachment handling
/// - Performance optimizations
/// 
class AdvancedDOOImplementation extends StatefulWidget {
  @override
  _AdvancedDOOImplementationState createState() => _AdvancedDOOImplementationState();
}

class _AdvancedDOOImplementationState extends State<AdvancedDOOImplementation> {
  DOOClient? _client;
  List<DOOMessage> _messages = [];
  bool _isConnected = false;
  bool _isAgentTyping = false;
  bool _isOnline = false;
  String _connectionStatus = "Connecting...";

  @override
  void initState() {
    super.initState();
    _initializeAdvancedDOOClient();
  }

  /// Initialize DOO client with comprehensive configuration
  Future<void> _initializeAdvancedDOOClient() async {
    try {
      _client = await DOOClient.create(
        baseUrl: "https://your-instance.doo.ooo",
        inboxIdentifier: "your_inbox_identifier",
        user: _createAdvancedUser(),
        callbacks: _createAdvancedCallbacks(),
        enablePersistence: true,
        locale: "en", // Can be dynamic based on user preference
      );

      await _client!.loadMessages();
    } catch (e) {
      setState(() => _connectionStatus = "Failed to connect: $e");
    }
  }

  /// Create a user with rich metadata and custom attributes
  DOOUser _createAdvancedUser() {
    return DOOUser(
      identifier: "user_${DateTime.now().millisecondsSinceEpoch}",
      name: "John Doe",
      email: "john.doe@example.com",
      avatarUrl: "https://example.com/avatar.jpg",
      customAttributes: {
        // User segmentation
        "user_type": "premium",
        "subscription_tier": "gold",
        "signup_date": "2023-01-15",
        "last_login": DateTime.now().toIso8601String(),
        
        // App context
        "app_version": "1.0.0",
        "platform": "mobile",
        "device_model": "iPhone 13",
        
        // Business context
        "total_orders": 15,
        "lifetime_value": 1250.0,
        "support_tier": "priority",
        
        // Behavioral data
        "timezone": "America/New_York",
        "language_preference": "en",
        "notification_preferences": {
          "email": true,
          "push": true,
          "sms": false,
        },
      },
    );
  }

  /// Create comprehensive event callbacks with advanced handling
  DOOCallbacks _createAdvancedCallbacks() {
    return DOOCallbacks(
      // Connection events
      onWelcome: () {
        setState(() {
          _isConnected = true;
          _connectionStatus = "Connected";
        });
        _showConnectionSnackBar("Connected to support", Colors.green);
      },

      onPing: () {
        // Handle keepalive - could update UI indicator
        debugPrint("Keepalive ping received");
      },

      onConfirmedSubscription: () {
        debugPrint("WebSocket subscription confirmed");
      },

      // Message events
      onMessageReceived: (message) {
        setState(() => _messages.add(message));
        
        // Show notification for new messages
        _showMessageNotification(message);
        
        // Analytics tracking
        _trackMessageReceived(message);
        
        // Auto-scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      },

      onMessageSent: (message, echoId) {
        // Replace optimistic message with confirmed one
        setState(() {
          _messages.removeWhere((msg) => 
            msg.content == message.content && msg.id < 0);
          _messages.add(message);
        });
        
        _trackMessageSent(message, echoId);
      },

      onMessageUpdated: (message) {
        // Handle message updates (edits, status changes)
        setState(() {
          final index = _messages.indexWhere((msg) => msg.id == message.id);
          if (index != -1) {
            _messages[index] = message;
          }
        });
      },

      // Conversation state events
      onConversationStartedTyping: () {
        setState(() => _isAgentTyping = true);
      },

      onConversationStoppedTyping: () {
        setState(() => _isAgentTyping = false);
      },

      onConversationIsOnline: () {
        setState(() => _isOnline = true);
        _showConnectionSnackBar("Agent is online", Colors.green);
      },

      onConversationIsOffline: () {
        setState(() => _isOnline = false);
        _showConnectionSnackBar("Agent is offline", Colors.orange);
      },

      // Data events
      onMessagesRetrieved: (messages) {
        setState(() {
          _messages = messages;
          _connectionStatus = "Messages loaded";
        });
      },

      onPersistedMessagesRetrieved: (messages) {
        setState(() => _messages = messages);
      },

      // Error handling
      onError: (error) {
        setState(() => _connectionStatus = "Error: ${error.cause}");
        _handleError(error);
      },
    );
  }

  /// Create a custom theme that matches your app's branding
  DOOChatTheme _createCustomTheme() {
    return DOOChatTheme(
      // Primary branding colors
      primaryColor: Color(0xFF6C5CE7),
      backgroundColor: Color(0xFFF8F9FA),
      
      // Message styling
      userMessageBackgroundColor: Color(0xFF6C5CE7),
      userMessageTextColor: Colors.white,
      botMessageBackgroundColor: Colors.white,
      botMessageTextColor: Color(0xFF2D3436),
      
      // Typography
      messageTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
      timestampTextStyle: TextStyle(
        fontSize: 11,
        color: Color(0xFF636E72),
        fontWeight: FontWeight.w500,
      ),
      
      // Input field styling
      inputBackgroundColor: Colors.white,
      inputTextColor: Color(0xFF2D3436),
      inputBorderColor: Color(0xFFDDD6FE),
      inputBorderRadius: BorderRadius.circular(24),
      
      // Status indicators
      onlineIndicatorColor: Color(0xFF00B894),
      offlineIndicatorColor: Color(0xFFE17055),
      typingIndicatorColor: Color(0xFF6C5CE7),
      
      // Message bubbles
      messageBorderRadius: 18.0,
      userMessageBorderRadius: BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(4),
        bottomLeft: Radius.circular(18),
        bottomRight: Radius.circular(18),
      ),
      botMessageBorderRadius: BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(18),
        bottomLeft: Radius.circular(18),
        bottomRight: Radius.circular(18),
      ),
      
      // Attachments
      attachmentIconColor: Color(0xFF636E72),
      attachmentBackgroundColor: Color(0xFFF1F3F4),
      
      // Error states
      errorColor: Color(0xFFE74C3C),
      
      // Shadows and elevation
      messageShadow: BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    );
  }

  /// Create localized text strings
  DOOLocalizations _createCustomLocalizations() {
    return DOOLocalizations(
      // Input field
      sendMessagePlaceholder: "Type your message...",
      sendButtonTooltip: "Send message",
      
      // Status messages
      onlineText: "We're online and ready to help!",
      offlineText: "We're currently away. Leave us a message and we'll get back to you soon.",
      typingText: "Agent is typing...",
      
      // Connection states
      connectingText: "Connecting to support...",
      connectedText: "Connected",
      reconnectingText: "Reconnecting...",
      
      // Actions
      attachmentButtonTooltip: "Attach file",
      cameraButtonTooltip: "Take photo",
      galleryButtonTooltip: "Choose from gallery",
      
      // Error messages
      connectionErrorText: "Connection failed. Please check your internet connection.",
      messageFailedText: "Message failed to send",
      attachmentFailedText: "Failed to attach file",
      
      // File attachments
      fileAttachmentText: "File attachment",
      imageAttachmentText: "Image",
      documentAttachmentText: "Document",
      
      // Timestamps
      todayText: "Today",
      yesterdayText: "Yesterday",
      
      // Accessibility
      messageAccessibilityLabel: "Message from",
      sendButtonAccessibilityLabel: "Send message button",
      attachmentButtonAccessibilityLabel: "Attach file button",
    );
  }

  /// Advanced error handling with user-friendly messages and recovery
  void _handleError(DOOError error) {
    String userMessage;
    Color backgroundColor;
    VoidCallback? action;

    switch (error.type) {
      case DOOErrorType.networkError:
        userMessage = "Network connection lost. Tap to retry.";
        backgroundColor = Colors.orange;
        action = () => _retryConnection();
        break;
      
      case DOOErrorType.authenticationError:
        userMessage = "Authentication failed. Please re-login.";
        backgroundColor = Colors.red;
        action = () => _handleReauthentication();
        break;
      
      case DOOErrorType.validationError:
        userMessage = "Invalid input. Please check your message.";
        backgroundColor = Colors.amber;
        break;
      
      case DOOErrorType.serverError:
        userMessage = "Server error. Our team has been notified.";
        backgroundColor = Colors.red;
        action = () => _reportError(error);
        break;
      
      default:
        userMessage = "Something went wrong. Please try again.";
        backgroundColor = Colors.grey;
        action = () => _retryLastAction();
    }

    _showErrorSnackBar(userMessage, backgroundColor, action);
    
    // Log error for analytics/debugging
    _logError(error);
  }

  /// Handle file attachments with advanced features
  Future<List<String>> _handleFileAttachment() async {
    try {
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Attach File"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Take Photo"),
                onTap: () => Navigator.pop(context, "camera"),
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Choose from Gallery"),
                onTap: () => Navigator.pop(context, "gallery"),
              ),
              ListTile(
                leading: Icon(Icons.attach_file),
                title: Text("Choose File"),
                onTap: () => Navigator.pop(context, "file"),
              ),
            ],
          ),
        ),
      );

      if (result != null) {
        switch (result) {
          case "camera":
            return await _pickImageFromCamera();
          case "gallery":
            return await _pickImageFromGallery();
          case "file":
            return await _pickFile();
          default:
            return [];
        }
      }
      return [];
    } catch (e) {
      _showErrorSnackBar("Failed to attach file: $e", Colors.red, null);
      return [];
    }
  }

  Future<List<String>> _pickImageFromCamera() async {
    // Implementation for camera capture
    // Using image_picker package
    return [];
  }

  Future<List<String>> _pickImageFromGallery() async {
    // Implementation for gallery selection
    return [];
  }

  Future<List<String>> _pickFile() async {
    // Implementation for file selection
    // Using file_picker package
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advanced DOO Chat"),
        subtitle: Text(_connectionStatus),
        actions: [
          // Online status indicator
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _isOnline ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  _isOnline ? "Online" : "Offline",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      body: DOOChatPage(
        websiteToken: "your_website_token",
        baseUrl: "https://your-instance.doo.ooo",
        user: _createAdvancedUser(),
        theme: _createCustomTheme(),
        l10n: _createCustomLocalizations(),
        enableAttachments: true,
        showUserNames: true,
        showUserAvatars: true,
        onAttachFile: _handleFileAttachment,
      ),
    );
  }

  // Helper methods
  void _showConnectionSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message, Color color, VoidCallback? action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        action: action != null
            ? SnackBarAction(
                label: "Retry",
                textColor: Colors.white,
                onPressed: action,
              )
            : null,
      ),
    );
  }

  void _showMessageNotification(DOOMessage message) {
    // Implementation for showing local notifications
    // Using flutter_local_notifications package
  }

  void _trackMessageReceived(DOOMessage message) {
    // Analytics tracking for received messages
    // Using firebase_analytics or similar
  }

  void _trackMessageSent(DOOMessage message, String echoId) {
    // Analytics tracking for sent messages
  }

  void _scrollToBottom() {
    // Implementation to scroll chat to bottom
  }

  void _retryConnection() async {
    setState(() => _connectionStatus = "Retrying...");
    try {
      await _client?.dispose();
      await _initializeAdvancedDOOClient();
    } catch (e) {
      setState(() => _connectionStatus = "Retry failed: $e");
    }
  }

  void _handleReauthentication() {
    // Handle user re-authentication
  }

  void _reportError(DOOError error) {
    // Report error to crash reporting service
  }

  void _retryLastAction() {
    // Retry the last failed action
  }

  void _logError(DOOError error) {
    // Log error for debugging/analytics
    debugPrint("DOO Error: ${error.cause} (Type: ${error.type})");
  }

  @override
  void dispose() {
    _client?.dispose();
    super.dispose();
  }
}

/// Extension class for additional theme properties
extension DOOChatThemeExtension on DOOChatTheme {
  DOOChatTheme copyWithAdvanced({
    Color? onlineIndicatorColor,
    Color? offlineIndicatorColor,
    Color? typingIndicatorColor,
    BorderRadius? userMessageBorderRadius,
    BorderRadius? botMessageBorderRadius,
    BoxShadow? messageShadow,
    Color? inputBorderColor,
  }) {
    return DOOChatTheme(
      // Copy all existing properties and override specific ones
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      // ... other properties
    );
  }
}

/// Custom localization class with additional strings
class AdvancedDOOLocalizations extends DOOLocalizations {
  final String connectingText;
  final String connectedText;
  final String reconnectingText;
  final String typingText;
  final String messageAccessibilityLabel;
  final String sendButtonAccessibilityLabel;
  final String attachmentButtonAccessibilityLabel;

  const AdvancedDOOLocalizations({
    required String sendMessagePlaceholder,
    required String onlineText,
    required String offlineText,
    required this.connectingText,
    required this.connectedText,
    required this.reconnectingText,
    required this.typingText,
    required this.messageAccessibilityLabel,
    required this.sendButtonAccessibilityLabel,
    required this.attachmentButtonAccessibilityLabel,
    // ... other parameters
  }) : super(
    sendMessagePlaceholder: sendMessagePlaceholder,
    onlineText: onlineText,
    offlineText: offlineText,
    // ... pass other parameters
  );
}