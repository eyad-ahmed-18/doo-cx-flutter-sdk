import 'package:doo_cx_flutter_sdk/data/doo_repository.dart';
import 'package:doo_cx_flutter_sdk/data/local/entity/doo_contact.dart';
import 'package:doo_cx_flutter_sdk/data/local/entity/doo_conversation.dart';
import 'package:doo_cx_flutter_sdk/data/remote/requests/doo_action_data.dart';
import 'package:doo_cx_flutter_sdk/data/remote/requests/doo_new_message_request.dart';
import 'package:doo_cx_flutter_sdk/di/modules.dart';
import 'package:doo_cx_flutter_sdk/doo_parameters.dart';
import 'package:doo_cx_flutter_sdk/repository_parameters.dart';
import 'package:riverpod/riverpod.dart';

import 'doo_callbacks.dart';
import 'data/local/entity/doo_user.dart';
import 'data/local/local_storage.dart';
import 'data/remote/doo_client_exception.dart';

/// Represents a DOO client instance. All DOO operations (Example: sendMessages) are
/// passed through DOO client. For more info visit
/// https://www.doo.ooo/docs/product/channels/api/client-apis
///
/// {@category FlutterClientSdk}
class DOOClient {
  late final DOORepository _repository;
  final DOOParameters _parameters;
  final DOOCallbacks? callbacks;
  final DOOUser? user;

  String get baseUrl => _parameters.baseUrl;

  String get inboxIdentifier => _parameters.inboxIdentifier;

  DOOClient._(this._parameters, {this.user, this.callbacks}) {
    providerContainerMap.putIfAbsent(
        _parameters.clientInstanceKey, () => ProviderContainer());
    final container = providerContainerMap[_parameters.clientInstanceKey]!;
    _repository = container.read(dooRepositoryProvider(RepositoryParameters(
        params: _parameters, callbacks: callbacks ?? DOOCallbacks())));
  }

  void _init() {
    try {
      _repository.initialize(user);
    } on DOOClientException catch (e) {
      callbacks?.onError?.call(e);
    }
  }

  ///Retrieves DOO client's messages. If persistence is enabled [DOOCallbacks.onPersistedMessagesRetrieved]
  ///will be triggered with persisted messages. On successfully fetch from remote server
  ///[DOOCallbacks.onMessagesRetrieved] will be triggered
  void loadMessages() async {
    _repository.getPersistedMessages();
    await _repository.getMessages();
  }

  /// Sends DOO message. The echoId is your temporary message id. When message sends successfully
  /// [DOOMessage] will be returned with the [echoId] on [DOOCallbacks.onMessageSent]. If
  /// message fails to send [DOOCallbacks.onError] will be triggered [echoId] as data.
  Future<void> sendMessage(
      {required String content, required String echoId}) async {
    final request = DOONewMessageRequest(content: content, echoId: echoId);
    await _repository.sendMessage(request);
  }

  ///Send DOO action performed by user.
  ///
  /// Example: User started typing
  Future<void> sendAction(DOOActionType action) async {
    _repository.sendAction(action);
  }

  ///Disposes DOO client and cancels all stream subscriptions
  dispose() {
    final container = providerContainerMap[_parameters.clientInstanceKey]!;
    _repository.dispose();
    container.dispose();
    providerContainerMap.remove(_parameters.clientInstanceKey);
  }

  /// Clears all DOO client data
  clearClientData() {
    final container = providerContainerMap[_parameters.clientInstanceKey]!;
    final localStorage = container.read(localStorageProvider(_parameters));
    localStorage.clear(clearDOOUserStorage: false);
  }

  /// Creates an instance of [DOOClient] with the [baseUrl] of your DOO installation,
  /// [inboxIdentifier] for the targeted inbox. Specify custom user details using [user] and [callbacks] for
  /// handling DOO events. By default persistence is enabled, to disable persistence set [enablePersistence] as false
  static Future<DOOClient> create(
      {required String baseUrl,
      required String inboxIdentifier,
      DOOUser? user,
      bool enablePersistence = true,
      DOOCallbacks? callbacks}) async {
    if (enablePersistence) {
      await LocalStorage.openDB();
    }

    final dooParams = DOOParameters(
        clientInstanceKey: getClientInstanceKey(
            baseUrl: baseUrl,
            inboxIdentifier: inboxIdentifier,
            userIdentifier: user?.identifier),
        isPersistenceEnabled: enablePersistence,
        baseUrl: baseUrl,
        inboxIdentifier: inboxIdentifier,
        userIdentifier: user?.identifier);

    final client = DOOClient._(dooParams, callbacks: callbacks, user: user);

    client._init();

    return client;
  }

  static final _keySeparator = "|||";

  ///Create a DOO client instance key using the DOO client instance baseurl, inboxIdentifier
  ///and userIdentifier. Client instance keys are used to differentiate between client instances and their data
  ///(contact ([DOOContact]),conversation ([DOOConversation]) and messages ([DOOMessage]))
  ///
  /// Create separate [DOOClient] instances with same baseUrl, inboxIdentifier, userIdentifier and persistence
  /// enabled will be regarded as same therefore use same contact and conversation.
  static String getClientInstanceKey(
      {required String baseUrl,
      required String inboxIdentifier,
      String? userIdentifier}) {
    return "$baseUrl$_keySeparator$userIdentifier$_keySeparator$inboxIdentifier";
  }

  static Map<String, ProviderContainer> providerContainerMap = Map();

  ///Clears all persisted DOO data on device for a particular DOO client instance.
  ///See [getClientInstanceKey] on how DOO client instance are differentiated
  static Future<void> clearData(
      {required String baseUrl,
      required String inboxIdentifier,
      String? userIdentifier}) async {
    final clientInstanceKey = getClientInstanceKey(
        baseUrl: baseUrl,
        inboxIdentifier: inboxIdentifier,
        userIdentifier: userIdentifier);
    providerContainerMap.putIfAbsent(
        clientInstanceKey, () => ProviderContainer());
    final container = providerContainerMap[clientInstanceKey]!;
    final params = DOOParameters(
        isPersistenceEnabled: true,
        baseUrl: "",
        inboxIdentifier: "",
        clientInstanceKey: "");

    final localStorage = container.read(localStorageProvider(params));
    await localStorage.clear();

    localStorage.dispose();
    container.dispose();
    providerContainerMap.remove(clientInstanceKey);
  }

  /// Clears all persisted DOO data on device.
  static Future<void> clearAllData() async {
    providerContainerMap.putIfAbsent("all", () => ProviderContainer());
    final container = providerContainerMap["all"]!;
    final params = DOOParameters(
        isPersistenceEnabled: true,
        baseUrl: "",
        inboxIdentifier: "",
        clientInstanceKey: "");

    final localStorage = container.read(localStorageProvider(params));
    await localStorage.clearAll();

    localStorage.dispose();
    container.dispose();
  }
}
