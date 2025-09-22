import 'package:doo_cx_flutter_sdk/data/local/entity/doo_contact.dart';
import 'package:doo_cx_flutter_sdk/data/local/entity/doo_conversation.dart';
import 'package:doo_cx_flutter_sdk/data/local/local_storage.dart';
import 'package:doo_cx_flutter_sdk/data/remote/service/doo_client_auth_service.dart';
import 'package:dio/dio.dart';
import 'package:synchronized/synchronized.dart' as synchronized;

///Intercepts network requests and attaches inbox identifier, contact identifiers, conversation identifiers
class DOOClientApiInterceptor extends Interceptor {
  static const INTERCEPTOR_INBOX_IDENTIFIER_PLACEHOLDER = "{INBOX_IDENTIFIER}";
  static const INTERCEPTOR_CONTACT_IDENTIFIER_PLACEHOLDER =
      "{CONTACT_IDENTIFIER}";
  static const INTERCEPTOR_CONVERSATION_IDENTIFIER_PLACEHOLDER =
      "{CONVERSATION_IDENTIFIER}";

  final String _inboxIdentifier;
  final LocalStorage _localStorage;
  final DOOClientAuthService _authService;
  final requestLock = synchronized.Lock();
  final responseLock = synchronized.Lock();

  DOOClientApiInterceptor(
      this._inboxIdentifier, this._localStorage, this._authService);

  /// Creates a new contact and conversation when no persisted contact is found when an api call is made
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    await requestLock.synchronized(() async {
      RequestOptions newOptions = options;
      DOOContact? contact = _localStorage.contactDao.getContact();
      DOOConversation? conversation =
          _localStorage.conversationDao.getConversation();

      if (contact == null) {
        // create new contact from user if no token found
        contact = await _authService.createNewContact(
            _inboxIdentifier, _localStorage.userDao.getUser());
        conversation = await _authService.createNewConversation(
            _inboxIdentifier, contact.contactIdentifier!);
        await _localStorage.conversationDao.saveConversation(conversation);
        await _localStorage.contactDao.saveContact(contact);
      }

      if (conversation == null) {
        conversation = await _authService.createNewConversation(
            _inboxIdentifier, contact.contactIdentifier!);
        await _localStorage.conversationDao.saveConversation(conversation);
      }

      newOptions.path = newOptions.path.replaceAll(
          INTERCEPTOR_INBOX_IDENTIFIER_PLACEHOLDER, _inboxIdentifier);
      newOptions.path = newOptions.path.replaceAll(
          INTERCEPTOR_CONTACT_IDENTIFIER_PLACEHOLDER,
          contact.contactIdentifier!);
      newOptions.path = newOptions.path.replaceAll(
          INTERCEPTOR_CONVERSATION_IDENTIFIER_PLACEHOLDER,
          "${conversation.id}");

      handler.next(newOptions);
    });
  }

  /// Clears and recreates contact when a 401 (Unauthorized), 403 (Forbidden) or 404 (Not found)
  /// response is returned from DOO public client api. Also handles 429 (Rate Limit) errors.
  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    await responseLock.synchronized(() async {
      // Handle rate limiting (429) by implementing exponential backoff
      if (response.statusCode == 429) {
        final retryAfter = response.headers['retry-after']?.first;
        int delaySeconds = 5; // Default delay
        
        if (retryAfter != null) {
          delaySeconds = int.tryParse(retryAfter) ?? 5;
        }
        
        // Cap the delay at 60 seconds for user experience
        delaySeconds = delaySeconds > 60 ? 60 : delaySeconds;
        
        print('DOO SDK: Rate limited. Retrying after $delaySeconds seconds...');
        
        // Wait for the specified delay
        await Future.delayed(Duration(seconds: delaySeconds));
        
        // Retry the request
        try {
          final retryResponse = await _authService.dio.fetch(response.requestOptions);
          handler.next(retryResponse);
          return;
        } catch (e) {
          print('DOO SDK: Retry failed: $e');
          handler.next(response); // Return original response if retry fails
          return;
        }
      }
      
      if (response.statusCode == 401 ||
          response.statusCode == 403 ||
          response.statusCode == 404) {
        await _localStorage.clear(clearDOOUserStorage: false);

        // create new contact from user if unauthorized,forbidden or not found
        final contact = _localStorage.contactDao.getContact()!;
        final conversation = await _authService.createNewConversation(
            _inboxIdentifier, contact.contactIdentifier!);
        await _localStorage.contactDao.saveContact(contact);
        await _localStorage.conversationDao.saveConversation(conversation);

        RequestOptions newOptions = response.requestOptions;

        newOptions.path = newOptions.path.replaceAll(
            INTERCEPTOR_INBOX_IDENTIFIER_PLACEHOLDER, _inboxIdentifier);
        newOptions.path = newOptions.path.replaceAll(
            INTERCEPTOR_CONTACT_IDENTIFIER_PLACEHOLDER,
            contact.contactIdentifier!);
        newOptions.path = newOptions.path.replaceAll(
            INTERCEPTOR_CONVERSATION_IDENTIFIER_PLACEHOLDER,
            "${conversation.id}");

        //use authservice's dio without the interceptor for subsequent call
        handler.next(await _authService.dio.fetch(newOptions));
      } else {
        // if response is not unauthorized, forbidden or not found forward response
        handler.next(response);
      }
    });
  }
}

extension Range on num {
  bool isBetween(num from, num to) {
    return from < this && this < to;
  }
}
