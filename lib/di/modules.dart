import 'package:doo_cx_flutter_sdk/data/doo_repository.dart';
import 'package:doo_cx_flutter_sdk/data/local/dao/doo_contact_dao.dart';
import 'package:doo_cx_flutter_sdk/data/local/dao/doo_conversation_dao.dart';
import 'package:doo_cx_flutter_sdk/data/local/dao/doo_messages_dao.dart';
import 'package:doo_cx_flutter_sdk/data/local/dao/doo_user_dao.dart';
import 'package:doo_cx_flutter_sdk/data/local/entity/doo_contact.dart';
import 'package:doo_cx_flutter_sdk/data/local/entity/doo_conversation.dart';
import 'package:doo_cx_flutter_sdk/data/local/entity/doo_message.dart';
import 'package:doo_cx_flutter_sdk/data/local/entity/doo_user.dart';
import 'package:doo_cx_flutter_sdk/data/local/local_storage.dart';
import 'package:doo_cx_flutter_sdk/data/remote/service/doo_client_api_interceptor.dart';
import 'package:doo_cx_flutter_sdk/data/remote/service/doo_client_auth_service.dart';
import 'package:doo_cx_flutter_sdk/data/remote/service/doo_client_service.dart';
import 'package:doo_cx_flutter_sdk/doo_parameters.dart';
import 'package:doo_cx_flutter_sdk/repository_parameters.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod/riverpod.dart';

///Provides an instance of [Dio]
final unauthenticatedDioProvider =
    Provider.family.autoDispose<Dio, DOOParameters>((ref, params) {
  return Dio(BaseOptions(baseUrl: params.baseUrl));
});

///Provides an instance of [DOOClientApiInterceptor]
final dooClientApiInterceptorProvider =
    Provider.family<DOOClientApiInterceptor, DOOParameters>((ref, params) {
  final localStorage = ref.read(localStorageProvider(params));
  final authService = ref.read(dooClientAuthServiceProvider(params));
  return DOOClientApiInterceptor(
      params.inboxIdentifier, localStorage, authService);
});

///Provides an instance of Dio with interceptors set to authenticate all requests called with this dio instance
final authenticatedDioProvider =
    Provider.family.autoDispose<Dio, DOOParameters>((ref, params) {
  final authenticatedDio = Dio(BaseOptions(baseUrl: params.baseUrl));
  final interceptor = ref.read(dooClientApiInterceptorProvider(params));
  authenticatedDio.interceptors.add(interceptor);
  return authenticatedDio;
});

///Provides instance of DOO client auth service [DOOClientAuthService].
final dooClientAuthServiceProvider =
    Provider.family<DOOClientAuthService, DOOParameters>((ref, params) {
  final unAuthenticatedDio = ref.read(unauthenticatedDioProvider(params));
  return DOOClientAuthServiceImpl(dio: unAuthenticatedDio);
});

///Provides instance of DOO client api service [DOOClientService].
final dooClientServiceProvider =
    Provider.family<DOOClientService, DOOParameters>((ref, params) {
  final authenticatedDio = ref.read(authenticatedDioProvider(params));
  return DOOClientServiceImpl(params.baseUrl, dio: authenticatedDio);
});

///Provides hive box to store relations between DOO client instance and contact object,
///which is used when persistence is enabled. Client instances are distinguished using baseurl and inboxIdentifier
final clientInstanceToContactBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>(
      DOOContactBoxNames.CLIENT_INSTANCE_TO_CONTACTS.toString());
});

///Provides hive box to store relations between DOO client instance and conversation object,
///which is used when persistence is enabled. Client instances are distinguished using baseurl and inboxIdentifier
final clientInstanceToConversationBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>(
      DOOConversationBoxNames.CLIENT_INSTANCE_TO_CONVERSATIONS.toString());
});

///Provides hive box to store relations between DOO client instance and messages,
///which is used when persistence is enabled. Client instances are distinguished using baseurl and inboxIdentifier
final messageToClientInstanceBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>(
      DOOMessagesBoxNames.MESSAGES_TO_CLIENT_INSTANCE_KEY.toString());
});

///Provides hive box to store relations between DOO client instance and user object,
///which is used when persistence is enabled. Client instances are distinguished using baseurl and inboxIdentifier
final clientInstanceToUserBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>(DOOUserBoxNames.CLIENT_INSTANCE_TO_USER.toString());
});

///Provides hive box for [DOOContact] object, which is used when persistence is enabled
final contactBoxProvider = Provider<Box<DOOContact>>((ref) {
  return Hive.box<DOOContact>(DOOContactBoxNames.CONTACTS.toString());
});

///Provides hive box for [DOOConversation] object, which is used when persistence is enabled
final conversationBoxProvider = Provider<Box<DOOConversation>>((ref) {
  return Hive.box<DOOConversation>(
      DOOConversationBoxNames.CONVERSATIONS.toString());
});

///Provides hive box for [DOOMessage] object, which is used when persistence is enabled
final messagesBoxProvider = Provider<Box<DOOMessage>>((ref) {
  return Hive.box<DOOMessage>(DOOMessagesBoxNames.MESSAGES.toString());
});

///Provides hive box for [DOOUser] object, which is used when persistence is enabled
final userBoxProvider = Provider<Box<DOOUser>>((ref) {
  return Hive.box<DOOUser>(DOOUserBoxNames.USERS.toString());
});

///Provides an instance of DOO user dao
///
/// Creates an in memory storage if persistence isn't enabled in params else hive boxes are create to store
/// DOO client's contact
final dooContactDaoProvider =
    Provider.family<DOOContactDao, DOOParameters>((ref, params) {
  if (!params.isPersistenceEnabled) {
    return NonPersistedDOOContactDao();
  }

  final contactBox = ref.read(contactBoxProvider);
  final clientInstanceToContactBox =
      ref.read(clientInstanceToContactBoxProvider);
  return PersistedDOOContactDao(
      contactBox, clientInstanceToContactBox, params.clientInstanceKey);
});

///Provides an instance of DOO user dao
///
/// Creates an in memory storage if persistence isn't enabled in params else hive boxes are create to store
/// DOO client's conversation
final dooConversationDaoProvider =
    Provider.family<DOOConversationDao, DOOParameters>((ref, params) {
  if (!params.isPersistenceEnabled) {
    return NonPersistedDOOConversationDao();
  }
  final conversationBox = ref.read(conversationBoxProvider);
  final clientInstanceToConversationBox =
      ref.read(clientInstanceToConversationBoxProvider);
  return PersistedDOOConversationDao(conversationBox,
      clientInstanceToConversationBox, params.clientInstanceKey);
});

///Provides an instance of DOO user dao
///
/// Creates an in memory storage if persistence isn't enabled in params else hive boxes are create to store
/// DOO client's messages
final dooMessagesDaoProvider =
    Provider.family<DOOMessagesDao, DOOParameters>((ref, params) {
  if (!params.isPersistenceEnabled) {
    return NonPersistedDOOMessagesDao();
  }
  final messagesBox = ref.read(messagesBoxProvider);
  final messageToClientInstanceBox =
      ref.read(messageToClientInstanceBoxProvider);
  return PersistedDOOMessagesDao(
      messagesBox, messageToClientInstanceBox, params.clientInstanceKey);
});

///Provides an instance of DOO user dao
///
/// Creates an in memory storage if persistence isn't enabled in params else hive boxes are create to store
/// user info
final dooUserDaoProvider =
    Provider.family<DOOUserDao, DOOParameters>((ref, params) {
  if (!params.isPersistenceEnabled) {
    return NonPersistedDOOUserDao();
  }
  final userBox = ref.read(userBoxProvider);
  final clientInstanceToUserBoxBox = ref.read(clientInstanceToUserBoxProvider);
  return PersistedDOOUserDao(
      userBox, clientInstanceToUserBoxBox, params.clientInstanceKey);
});

///Provides an instance of local storage
final localStorageProvider =
    Provider.family<LocalStorage, DOOParameters>((ref, params) {
  final contactDao = ref.read(dooContactDaoProvider(params));
  final conversationDao = ref.read(dooConversationDaoProvider(params));
  final userDao = ref.read(dooUserDaoProvider(params));
  final messagesDao = ref.read(dooMessagesDaoProvider(params));

  return LocalStorage(
      contactDao: contactDao,
      conversationDao: conversationDao,
      userDao: userDao,
      messagesDao: messagesDao);
});

///Provides an instance of DOO repository
final dooRepositoryProvider =
    Provider.family<DOORepository, RepositoryParameters>((ref, repoParams) {
  final localStorage = ref.read(localStorageProvider(repoParams.params));
  final clientService = ref.read(dooClientServiceProvider(repoParams.params));

  return DOORepositoryImpl(
      clientService: clientService,
      localStorage: localStorage,
      streamCallbacks: repoParams.callbacks);
});
