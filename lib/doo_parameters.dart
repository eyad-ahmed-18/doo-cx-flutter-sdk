import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Extension to convert Color to hex string
extension ColorToHex on Color {
  String toHex() {
    final r = ((this.r * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    final g = ((this.g * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    final b = ((this.b * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    return '#$r$g$b';
  }
}

/// Class containing parameters for DOO client configuration
/// 
/// Used for initializing DOO client with proper configuration settings
class DOOParameters extends Equatable {
  /// Whether to enable persistence of conversation data
  final bool isPersistenceEnabled;
  
  /// Base URL of your DOO installation
  final String baseUrl;
  
  /// Unique key to identify this client instance
  final String clientInstanceKey;
  
  /// SDK token for Flutter SDK channel authentication (RECOMMENDED)
  /// This is the preferred token for native Flutter applications
  final String? sdkToken;
  
  /// Inbox identifier for direct inbox connection (alternative to sdkToken)
  /// Use this when you have the inbox identifier directly
  final String? inboxIdentifier;
  
  /// Optional user identifier for conversation tracking
  final String? userIdentifier;
  
  /// Website token for widget authentication (used in webview integration only)
  /// @deprecated Use sdkToken for native Flutter apps
  final String? websiteToken;
  
  /// Optional locale setting (e.g., 'en', 'fr', 'es')
  final String? locale;
  
  /// Optional custom attributes for the contact
  final Map<String, dynamic>? customAttributes;
  
  /// Enable/disable push notifications (default: true)
  final bool enablePushNotifications;
  
  /// Enable/disable file attachments (default: true)
  final bool enableFileAttachments;
  
  /// Enable/disable emoji picker (default: true)
  final bool enableEmojiPicker;
  
  /// Enable/disable typing indicators (default: true)
  final bool enableTypingIndicators;
  
  /// Enable/disable read receipts (default: true)
  final bool enableReadReceipts;
  
  /// Theme color for the SDK UI (default: DOO blue)
  final Color themeColor;
  
  /// Duration after which inactive conversations are auto-resolved
  final Duration autoResolveInactiveConversations;
  
  /// Enable/disable messaging window (default: true)
  final bool messagingWindowEnabled;
  
  /// Custom welcome message
  final String? welcomeMessage;
  
  /// Message displayed when agents are offline
  final String? offlineMessage;
  
  /// Message displayed when agents are away
  final String? agentAwayMessage;
  
  /// Additional contact custom attributes
  final Map<String, String>? contactCustomAttributes;

  /// Creates a DOOParameters instance with required configuration
  /// 
  /// Either [sdkToken] OR [inboxIdentifier] must be provided:
  /// - Use [sdkToken] for Flutter SDK channels (recommended)
  /// - Use [inboxIdentifier] for direct inbox access
  /// - Use [websiteToken] only for webview integration
  DOOParameters({
    required this.isPersistenceEnabled,
    required this.baseUrl,
    required this.clientInstanceKey,
    this.sdkToken,
    this.inboxIdentifier,
    this.userIdentifier,
    this.websiteToken,
    this.locale,
    this.customAttributes,
    this.enablePushNotifications = true,
    this.enableFileAttachments = true,
    this.enableEmojiPicker = true,
    this.enableTypingIndicators = true,
    this.enableReadReceipts = true,
    this.themeColor = const Color(0xFF1f93ff),
    this.autoResolveInactiveConversations = const Duration(days: 30),
    this.messagingWindowEnabled = true,
    this.welcomeMessage,
    this.offlineMessage,
    this.agentAwayMessage,
    this.contactCustomAttributes,
  }) : assert(
    sdkToken != null || inboxIdentifier != null || websiteToken != null,
    'Either sdkToken, inboxIdentifier, or websiteToken must be provided'
  );

  /// Creates parameters for Flutter SDK channel (recommended)
  DOOParameters.forFlutterSDK({
    required this.baseUrl,
    required this.sdkToken,
    required this.clientInstanceKey,
    this.isPersistenceEnabled = true,
    this.userIdentifier,
    this.locale,
    this.customAttributes,
    this.enablePushNotifications = true,
    this.enableFileAttachments = true,
    this.enableEmojiPicker = true,
    this.enableTypingIndicators = true,
    this.enableReadReceipts = true,
    this.themeColor = const Color(0xFF1f93ff),
    this.autoResolveInactiveConversations = const Duration(days: 30),
    this.messagingWindowEnabled = true,
    this.welcomeMessage,
    this.offlineMessage,
    this.agentAwayMessage,
    this.contactCustomAttributes,
  }) : inboxIdentifier = null,
       websiteToken = null;

  /// Creates parameters for webview integration (legacy)
  DOOParameters.forWebView({
    required this.baseUrl,
    required this.websiteToken,
    required this.clientInstanceKey,
    this.isPersistenceEnabled = true,
    this.userIdentifier,
    this.locale,
    this.customAttributes,
    this.enablePushNotifications = false, // Not applicable for webview
    this.enableFileAttachments = true,
    this.enableEmojiPicker = true,
    this.enableTypingIndicators = true,
    this.enableReadReceipts = true,
    this.themeColor = const Color(0xFF1f93ff),
    this.autoResolveInactiveConversations = const Duration(days: 30),
    this.messagingWindowEnabled = true,
    this.welcomeMessage,
    this.offlineMessage,
    this.agentAwayMessage,
    this.contactCustomAttributes,
  }) : sdkToken = null,
       inboxIdentifier = null;

  /// Creates parameters for direct inbox access
  DOOParameters.forInbox({
    required this.baseUrl,
    required this.inboxIdentifier,
    required this.clientInstanceKey,
    this.isPersistenceEnabled = true,
    this.userIdentifier,
    this.locale,
    this.customAttributes,
    this.enablePushNotifications = true,
    this.enableFileAttachments = true,
    this.enableEmojiPicker = true,
    this.enableTypingIndicators = true,
    this.enableReadReceipts = true,
    this.themeColor = const Color(0xFF1f93ff),
    this.autoResolveInactiveConversations = const Duration(days: 30),
    this.messagingWindowEnabled = true,
    this.welcomeMessage,
    this.offlineMessage,
    this.agentAwayMessage,
    this.contactCustomAttributes,
  }) : sdkToken = null,
       websiteToken = null;

  /// Converts parameters to a map for serialization
  Map<String, dynamic> toMap() {
    return {
      'isPersistenceEnabled': isPersistenceEnabled,
      'baseUrl': baseUrl,
      'clientInstanceKey': clientInstanceKey,
      'sdkToken': sdkToken,
      'inboxIdentifier': inboxIdentifier,
      'userIdentifier': userIdentifier,
      'websiteToken': websiteToken,
      'locale': locale,
      'customAttributes': customAttributes,
      'enablePushNotifications': enablePushNotifications,
      'enableFileAttachments': enableFileAttachments,
      'enableEmojiPicker': enableEmojiPicker,
      'enableTypingIndicators': enableTypingIndicators,
      'enableReadReceipts': enableReadReceipts,
      'themeColor': themeColor.toHex(),
      'autoResolveInactiveConversations': autoResolveInactiveConversations.inDays,
      'messagingWindowEnabled': messagingWindowEnabled,
      'welcomeMessage': welcomeMessage,
      'offlineMessage': offlineMessage,
      'agentAwayMessage': agentAwayMessage,
      'contactCustomAttributes': contactCustomAttributes,
    };
  }

  /// Creates a copy of this instance with modified values
  DOOParameters copyWith({
    bool? isPersistenceEnabled,
    String? baseUrl,
    String? clientInstanceKey,
    String? sdkToken,
    String? inboxIdentifier,
    String? userIdentifier,
    String? websiteToken,
    String? locale,
    Map<String, dynamic>? customAttributes,
    bool? enablePushNotifications,
    bool? enableFileAttachments,
    bool? enableEmojiPicker,
    bool? enableTypingIndicators,
    bool? enableReadReceipts,
    Color? themeColor,
    Duration? autoResolveInactiveConversations,
    bool? messagingWindowEnabled,
    String? welcomeMessage,
    String? offlineMessage,
    String? agentAwayMessage,
    Map<String, String>? contactCustomAttributes,
  }) {
    return DOOParameters(
      isPersistenceEnabled: isPersistenceEnabled ?? this.isPersistenceEnabled,
      baseUrl: baseUrl ?? this.baseUrl,
      clientInstanceKey: clientInstanceKey ?? this.clientInstanceKey,
      sdkToken: sdkToken ?? this.sdkToken,
      inboxIdentifier: inboxIdentifier ?? this.inboxIdentifier,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      websiteToken: websiteToken ?? this.websiteToken,
      locale: locale ?? this.locale,
      customAttributes: customAttributes ?? this.customAttributes,
      enablePushNotifications: enablePushNotifications ?? this.enablePushNotifications,
      enableFileAttachments: enableFileAttachments ?? this.enableFileAttachments,
      enableEmojiPicker: enableEmojiPicker ?? this.enableEmojiPicker,
      enableTypingIndicators: enableTypingIndicators ?? this.enableTypingIndicators,
      enableReadReceipts: enableReadReceipts ?? this.enableReadReceipts,
      themeColor: themeColor ?? this.themeColor,
      autoResolveInactiveConversations: autoResolveInactiveConversations ?? this.autoResolveInactiveConversations,
      messagingWindowEnabled: messagingWindowEnabled ?? this.messagingWindowEnabled,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      offlineMessage: offlineMessage ?? this.offlineMessage,
      agentAwayMessage: agentAwayMessage ?? this.agentAwayMessage,
      contactCustomAttributes: contactCustomAttributes ?? this.contactCustomAttributes,
    );
  }

  @override
  List<Object?> get props => [
        isPersistenceEnabled,
        baseUrl,
        clientInstanceKey,
        sdkToken,
        inboxIdentifier,
        userIdentifier,
        websiteToken,
        locale,
        customAttributes,
        enablePushNotifications,
        enableFileAttachments,
        enableEmojiPicker,
        enableTypingIndicators,
        enableReadReceipts,
        themeColor,
        autoResolveInactiveConversations,
        messagingWindowEnabled,
        welcomeMessage,
        offlineMessage,
        agentAwayMessage,
        contactCustomAttributes,
      ];

  @override
  String toString() {
    return 'DOOParameters(baseUrl: $baseUrl, sdkToken: ${sdkToken != null ? '[HIDDEN]' : null}, '
           'inboxIdentifier: $inboxIdentifier, websiteToken: ${websiteToken != null ? '[HIDDEN]' : null})';
  }
}
