import 'dart:async';

import 'package:doo_cx_flutter_sdk/data/local/entity/doo_contact.dart';
import 'package:doo_cx_flutter_sdk/data/local/entity/doo_conversation.dart';
import 'package:doo_cx_flutter_sdk/data/local/entity/doo_user.dart';
import 'package:doo_cx_flutter_sdk/data/remote/doo_client_exception.dart';
import 'package:doo_cx_flutter_sdk/data/remote/service/doo_client_api_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Service for handling DOO user authentication api calls
/// See [DOOClientAuthServiceImpl]
abstract class DOOClientAuthService {
  WebSocketChannel? connection;
  final Dio dio;

  DOOClientAuthService(this.dio);

  Future<DOOContact> createNewContact(String inboxIdentifier, DOOUser? user);

  Future<DOOConversation> createNewConversation(
      String inboxIdentifier, String contactIdentifier);
}

/// Default Implementation for [DOOClientAuthService]
class DOOClientAuthServiceImpl extends DOOClientAuthService {
  DOOClientAuthServiceImpl({required Dio dio}) : super(dio);

  ///Creates new contact for inbox with [inboxIdentifier] and passes [user] body to be linked to created contact
  @override
  Future<DOOContact> createNewContact(
      String inboxIdentifier, DOOUser? user) async {
    try {
      final createResponse = await dio.post(
          "/public/api/v1/inboxes/$inboxIdentifier/contacts",
          data: user?.toJson());
      if ((createResponse.statusCode ?? 0).isBetween(199, 300)) {
        //creating contact successful continue with request
        final contact = DOOContact.fromJson(createResponse.data);
        return contact;
      } else {
        throw DOOClientException(
            createResponse.statusMessage ?? "unknown error",
            DOOClientExceptionType.CREATE_CONTACT_FAILED);
      }
    } on DioException catch (e) {
      throw DOOClientException(
          e.message!, DOOClientExceptionType.CREATE_CONTACT_FAILED);
    }
  }

  ///Creates a new conversation for inbox with [inboxIdentifier] and contact with source id [contactIdentifier]
  @override
  Future<DOOConversation> createNewConversation(
      String inboxIdentifier, String contactIdentifier) async {
    try {
      final createResponse = await dio.post(
          "/public/api/v1/inboxes/$inboxIdentifier/contacts/$contactIdentifier/conversations");
      if ((createResponse.statusCode ?? 0).isBetween(199, 300)) {
        //creating contact successful continue with request
        final newConversation = DOOConversation.fromJson(createResponse.data);
        return newConversation;
      } else {
        throw DOOClientException(
            createResponse.statusMessage ?? "unknown error",
            DOOClientExceptionType.CREATE_CONVERSATION_FAILED);
      }
    } on DioException catch (e) {
      throw DOOClientException(
          e.message!, DOOClientExceptionType.CREATE_CONVERSATION_FAILED);
    }
  }
}
