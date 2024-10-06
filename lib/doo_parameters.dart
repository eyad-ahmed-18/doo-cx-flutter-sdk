import 'package:equatable/equatable.dart';

class DOOParameters extends Equatable {
  final bool isPersistenceEnabled;
  final String baseUrl;
  final String clientInstanceKey;
  final String inboxIdentifier;
  final String? userIdentifier;

  DOOParameters(
      {required this.isPersistenceEnabled,
      required this.baseUrl,
      required this.inboxIdentifier,
      required this.clientInstanceKey,
      this.userIdentifier});

  @override
  List<Object?> get props => [
        isPersistenceEnabled,
        baseUrl,
        clientInstanceKey,
        inboxIdentifier,
        userIdentifier
      ];
}
