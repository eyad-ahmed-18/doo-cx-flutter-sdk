import 'package:flutter/material.dart';
import 'package:doo_cx_flutter_sdk/doo_cx_flutter_sdk.dart';

/// Advanced implementation example showing all DOO CX Flutter SDK features
/// This demonstrates customization, error handling, theming, and best practices
class AdvancedImplementationExample extends StatefulWidget {
  const AdvancedImplementationExample({Key? key}) : super(key: key);

  @override
  State<AdvancedImplementationExample> createState() => _AdvancedImplementationExampleState();
}

class _AdvancedImplementationExampleState extends State<AdvancedImplementationExample> {
  DOOClient? _client;
  String _connectionStatus = 'Disconnected';
  int _messageCount = 0;
  bool _isTyping = false;
  final List<String> _errorLog = [];
  final List<String> _analyticsLog = [];

  @override
  void initState() {
    super.initState();
    _initializeAdvancedClient();
  }

  @override
  void dispose() {
    _client?.dispose();
    super.dispose();
  }

  /// Initialize DOO client with advanced configuration
  Future<void> _initializeAdvancedClient() async {
    try {
      setState(() {
        _connectionStatus = 'Connecting...';
      });

      _client = await DOOClient.create(
        baseUrl: 'http://localhost:3001',
        inboxIdentifier: 'advanced-example-inbox',
        enablePersistence: true,
        user: DOOUser(
          identifier: 'advanced_user_001',
          name: 'Advanced Demo User',
          email: 'advanced@example.com',
          avatarUrl: 'https://via.placeholder.com/150',
          customAttributes: {
            'user_type': 'premium',
            'plan': 'enterprise',
            'signup_date': DateTime.now().toIso8601String(),
            'timezone': 'UTC',
            'language_preference': 'en',
          },
        ),
        callbacks: DOOCallbacks(
          onWelcome: _handleWelcome,
          onPing: _handlePing,
          onConfirmedSubscription: _handleConfirmedSubscription,
          onConversationStartedTyping: _handleTypingStarted,
          onConversationStoppedTyping: _handleTypingStopped,
          onConversationIsOnline: _handleConversationOnline,
          onConversationIsOffline: _handleConversationOffline,
          onMessageReceived: _handleMessageReceived,
          onMessageSent: _handleMessageSent,
          onMessageDelivered: _handleMessageDelivered,
          onMessageUpdated: _handleMessageUpdated,
          onPersistedMessagesRetrieved: _handlePersistedMessagesRetrieved,
          onMessagesRetrieved: _handleMessagesRetrieved,
          onError: _handleError,
        ),
      );

      // Load previous messages
      await _client!.loadMessages();

      setState(() {
        _connectionStatus = 'Connected';
      });

      _logAnalytics('Client initialized successfully');
    } catch (e) {
      setState(() {
        _connectionStatus = 'Failed to connect';
      });
      _handleError(DOOClientException('Failed to initialize client: $e', DOOClientExceptionType.CREATE_CLIENT_FAILED));
    }
  }

  // Event Handlers
  void _handleWelcome() {
    _logAnalytics('Welcome event received');
  }

  void _handlePing() {
    _logAnalytics('Ping received - connection healthy');
  }

  void _handleConfirmedSubscription() {
    setState(() {
      _connectionStatus = 'Subscribed';
    });
    _logAnalytics('Subscription confirmed');
  }

  void _handleTypingStarted() {
    setState(() {
      _isTyping = true;
    });
    _logAnalytics('Agent started typing');
  }

  void _handleTypingStopped() {
    setState(() {
      _isTyping = false;
    });
    _logAnalytics('Agent stopped typing');
  }

  void _handleConversationOnline() {
    setState(() {
      _connectionStatus = 'Online';
    });
    _logAnalytics('Conversation is online');
  }

  void _handleConversationOffline() {
    setState(() {
      _connectionStatus = 'Offline';
    });
    _logAnalytics('Conversation is offline');
  }

  void _handleMessageReceived(DOOMessage message) {
    setState(() {
      _messageCount++;
    });
    _logAnalytics('Message received: ${message.content}');
    
    // Show notification for new messages
    _showMessageNotification('New message: ${message.content}');
  }

  void _handleMessageSent(DOOMessage message, String echoId) {
    _logAnalytics('Message sent: ${message.content} (echo: $echoId)');
  }

  void _handleMessageDelivered(DOOMessage message, String echoId) {
    _logAnalytics('Message delivered: ${message.id} (echo: $echoId)');
  }

  void _handleMessageUpdated(DOOMessage message) {
    _logAnalytics('Message updated: ${message.id}');
  }

  void _handlePersistedMessagesRetrieved(List<DOOMessage> messages) {
    _logAnalytics('${messages.length} persisted messages retrieved');
  }

  void _handleMessagesRetrieved(List<DOOMessage> messages) {
    setState(() {
      _messageCount = messages.length;
    });
    _logAnalytics('${messages.length} messages retrieved from server');
  }

  void _handleError(DOOClientException error) {
    setState(() {
      _errorLog.add('${DateTime.now()}: ${error.cause}');
    });
    
    // Handle different error types
    switch (error.type) {
      case DOOClientExceptionType.CREATE_CLIENT_FAILED:
        _showErrorDialog('Connection Failed', 'Failed to connect to DOO. Please check your internet connection.');
        break;
      case DOOClientExceptionType.SEND_MESSAGE_FAILED:
        _showErrorDialog('Send Failed', 'Your message could not be sent. Please try again.');
        break;
      case DOOClientExceptionType.GET_MESSAGES_FAILED:
        _showErrorDialog('Load Failed', 'Could not load messages. Please refresh.');
        break;
      default:
        _showErrorDialog('Error', error.cause);
    }
    
    _reportError(error);
  }

  // Helper Methods
  void _showMessageNotification(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  void _showErrorDialog(String title, String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _logAnalytics(String event) {
    setState(() {
      _analyticsLog.add('${DateTime.now().toIso8601String()}: $event');
    });
    // In a real app, you would send this to your analytics service
    print('Analytics: $event');
  }

  void _reportError(DOOClientException error) {
    // In a real app, you would report this to your error tracking service
    print('Error reported: ${error.cause}');
  }

  void _clearLogs() {
    setState(() {
      _errorLog.clear();
      _analyticsLog.clear();
    });
  }

  // Custom Theme
  DOOChatTheme _createCustomTheme() {
    return const DOOChatTheme(
      primaryColor: Color(0xFF6C5CE7),
      backgroundColor: Color(0xFFF8F9FA),
      inputBackgroundColor: Color(0xFFFFFFFF),
      inputTextColor: Color(0xFF2D3748),
      receivedMessageBodyTextStyle: TextStyle(
        color: Color(0xFF2D3748),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      sentMessageBodyTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // Custom Localizations
  DOOL10n _createCustomLocalizations() {
    return const DOOL10n(
      inputPlaceholder: 'Type your message here...',
      onlineText: 'We are online and ready to help!',
      offlineText: 'We are currently offline. Leave us a message!',
      typingText: 'Agent is typing...',
      conversationResolvedMessage: 'This conversation has been resolved. Thank you!',
      emptyChatPlaceholder: 'Start a conversation with us!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced DOO Implementation'),
        backgroundColor: const Color(0xFF6C5CE7),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeAdvancedClient,
            tooltip: 'Reconnect',
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearLogs,
            tooltip: 'Clear logs',
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: _connectionStatus == 'Connected' 
                ? Colors.green.shade100 
                : _connectionStatus == 'Connecting...'
                    ? Colors.orange.shade100
                    : Colors.red.shade100,
            child: Row(
              children: [
                Icon(
                  _connectionStatus == 'Connected' 
                      ? Icons.wifi 
                      : _connectionStatus == 'Connecting...'
                          ? Icons.wifi_outlined
                          : Icons.wifi_off,
                  color: _connectionStatus == 'Connected' 
                      ? Colors.green.shade700 
                      : _connectionStatus == 'Connecting...'
                          ? Colors.orange.shade700
                          : Colors.red.shade700,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status: $_connectionStatus',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _connectionStatus == 'Connected' 
                              ? Colors.green.shade700 
                              : _connectionStatus == 'Connecting...'
                                  ? Colors.orange.shade700
                                  : Colors.red.shade700,
                        ),
                      ),
                      Text(
                        'Messages: $_messageCount${_isTyping ? ' • Agent typing...' : ''}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Chat Interface
          Expanded(
            flex: 3,
            child: _client != null 
                ? DOOChat(
                    baseUrl: 'http://localhost:3001',
                    inboxIdentifier: 'advanced-example-inbox',
                    user: DOOUser(
                      identifier: 'advanced_user_001',
                      name: 'Advanced Demo User',
                      email: 'advanced@example.com',
                    ),
                    theme: _createCustomTheme(),
                    l10n: _createCustomLocalizations(),
                    enablePersistence: true,
                    onMessageReceived: _handleMessageReceived,
                    onError: _handleError,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          
          // Logs Section
          Expanded(
            flex: 2,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Analytics'),
                      Tab(text: 'Errors'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Analytics Log
                        ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _analyticsLog.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            final log = _analyticsLog[_analyticsLog.length - 1 - index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  log,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        
                        // Error Log
                        ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _errorLog.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            final error = _errorLog[_errorLog.length - 1 - index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              color: Colors.red.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  error,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                    color: Colors.red.shade800,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}