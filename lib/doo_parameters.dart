import 'package:equatable/equatable.dart';

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
  
  /// Identifier for the DOO inbox to connect to
  final String inboxIdentifier;
  
  /// Optional user identifier for conversation tracking
  final String? userIdentifier;
  
  /// Website token for widget authentication (used in webview integration)
  final String? websiteToken;
  
  /// Optional locale setting (e.g., 'en', 'fr')
  final String? locale;

  /// Creates a DOOParameters instance with required configuration
  DOOParameters({
    required this.isPersistenceEnabled,
    required this.baseUrl,
    required this.inboxIdentifier,
    required this.clientInstanceKey,
    this.userIdentifier,
    this.websiteToken,
    this.locale,
  });

  @override
  List<Object?> get props => [
        isPersistenceEnabled,
        baseUrl,
        clientInstanceKey,
        inboxIdentifier,
        userIdentifier,
        websiteToken,
        locale
      ];
}
