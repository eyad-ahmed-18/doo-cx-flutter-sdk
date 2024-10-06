import 'package:doo_cx_flutter_sdk/data/doo_repository.dart';
import 'package:doo_cx_flutter_sdk/data/local/entity/doo_message.dart';
import 'package:doo_cx_flutter_sdk/data/remote/doo_client_exception.dart';
import 'package:doo_cx_flutter_sdk/data/remote/responses/doo_event.dart';

///DOO callback are specified for each created client instance. Methods are triggered
///when a method satisfying their respective conditions occur.
///
///
/// {@category FlutterClientSdk}
class DOOCallbacks {
  ///Triggered when a welcome event/message is received after connecting to
  ///the DOO websocket. See [DOORepository.listenForEvents]
  void Function()? onWelcome;

  ///Triggered when a ping event/message is received after connecting to
  ///the DOO websocket. See [DOORepository.listenForEvents]
  void Function()? onPing;

  ///Triggered when a subscription confirmation event/message is received after connecting to
  ///the DOO websocket. See [DOORepository.listenForEvents]
  void Function()? onConfirmedSubscription;

  ///Triggered when a conversation typing on event/message [DOOEventMessageType.conversation_typing_on]
  ///is received after connecting to the DOO websocket. See [DOORepository.listenForEvents]
  void Function()? onConversationStartedTyping;

  ///Triggered when a presence update event/message [DOOEventMessageType.presence_update]
  ///is received after connecting to the DOO websocket and conversation is online. See [DOORepository.listenForEvents]
  void Function()? onConversationIsOnline;

  ///Triggered when a presence update event/message [DOOEventMessageType.presence_update]
  ///is received after connecting to the DOO websocket and conversation is offline.
  ///See [DOORepository.listenForEvents]
  void Function()? onConversationIsOffline;

  ///Triggered when a conversation typing off event/message [DOOEventMessageType.conversation_typing_off]
  ///is received after connecting to the DOO websocket. See [DOORepository.listenForEvents]
  void Function()? onConversationStoppedTyping;

  ///Triggered when a message created event/message [DOOEventMessageType.message_created]
  ///is received and message doesn't belong to current user after connecting to the DOO websocket.
  ///See [DOORepository.listenForEvents]
  void Function(DOOMessage)? onMessageReceived;

  ///Triggered when a message created event/message [DOOEventMessageType.message_updated]
  ///is received after connecting to the DOO websocket.
  ///See [DOORepository.listenForEvents]
  void Function(DOOMessage)? onMessageUpdated;

  void Function(DOOMessage, String)? onMessageSent;

  ///Triggered when a message created event/message [DOOEventMessageType.message_created]
  ///is received and message belongs to current user after connecting to the DOO websocket.
  ///See [DOORepository.listenForEvents]
  void Function(DOOMessage, String)? onMessageDelivered;

  ///Triggered when a conversation's messages persisted on device are successfully retrieved
  void Function(List<DOOMessage>)? onPersistedMessagesRetrieved;

  ///Triggered when a conversation's messages is successfully retrieved from remote server
  void Function(List<DOOMessage>)? onMessagesRetrieved;

  ///Triggered when an agent resolves the current conversation
  void Function()? onConversationResolved;

  /// Triggered when any error occurs in DOO client's operations with the error
  ///
  /// See [DOOClientExceptionType] for the various types of exceptions that can be triggered
  void Function(DOOClientException)? onError;

  DOOCallbacks({
    this.onWelcome,
    this.onPing,
    this.onConfirmedSubscription,
    this.onMessageReceived,
    this.onMessageSent,
    this.onMessageDelivered,
    this.onMessageUpdated,
    this.onPersistedMessagesRetrieved,
    this.onMessagesRetrieved,
    this.onConversationStartedTyping,
    this.onConversationStoppedTyping,
    this.onConversationIsOnline,
    this.onConversationIsOffline,
    this.onConversationResolved,
    this.onError,
  });
}
