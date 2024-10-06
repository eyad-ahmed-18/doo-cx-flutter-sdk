import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

const DOO_COLOR_PRIMARY = Color(0xff1f93ff);
const DOO_BG_COLOR = Color(0xfff4f6fb);
const DOO_AVATAR_COLORS = [DOO_COLOR_PRIMARY];

/// Default DOO chat theme which extends [ChatTheme]
@immutable
class DOOChatTheme extends ChatTheme {
  /// Creates a DOO chat theme. Use this constructor if you want to
  /// override only a couple of variables.
  const DOOChatTheme(
      {Widget? attachmentButtonIcon,
      Color backgroundColor = DOO_BG_COLOR,
      TextStyle dateDividerTextStyle = const TextStyle(
        color: Colors.black26,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        height: 1.333,
      ),
      Widget? deliveredIcon,
      Widget? documentIcon,
      TextStyle emptyChatPlaceholderTextStyle = const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      Color errorColor = Colors.red,
      Widget? errorIcon,
      Color inputBackgroundColor = Colors.white,
      BorderRadius inputBorderRadius = const BorderRadius.all(
        Radius.circular(10),
      ),
      Color inputTextColor = Colors.black87,
      TextStyle inputTextStyle = const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      double messageBorderRadius = 20.0,
      Color primaryColor = DOO_COLOR_PRIMARY,
      TextStyle receivedMessageBodyTextStyle = const TextStyle(
        color: Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      TextStyle receivedMessageCaptionTextStyle = const TextStyle(
        color: Colors.greenAccent,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.333,
      ),
      Color receivedMessageDocumentIconColor = Colors.green,
      TextStyle receivedMessageLinkDescriptionTextStyle = const TextStyle(
        color: Colors.greenAccent,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.428,
      ),
      TextStyle receivedMessageLinkTitleTextStyle = const TextStyle(
        color: Colors.blueAccent,
        fontSize: 16,
        fontWeight: FontWeight.w800,
        height: 1.375,
      ),
      Color secondaryColor = Colors.white,
      Widget? seenIcon,
      Widget? sendButtonIcon,
      Widget? sendingIcon,
      TextStyle sentMessageBodyTextStyle = const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      TextStyle sentMessageCaptionTextStyle = const TextStyle(
        color: Colors.amber,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.333,
      ),
      Color sentMessageDocumentIconColor = Colors.blueGrey,
      TextStyle sentMessageLinkDescriptionTextStyle = const TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.428,
      ),
      TextStyle sentMessageLinkTitleTextStyle = const TextStyle(
        color: Colors.amberAccent,
        fontSize: 16,
        fontWeight: FontWeight.w800,
        height: 1.375,
      ),
      List<Color> userAvatarNameColors = DOO_AVATAR_COLORS,
      TextStyle userAvatarTextStyle = const TextStyle(
        color: Colors.orange,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        height: 1.333,
      ),
      TextStyle userNameTextStyle = const TextStyle(
        color: Colors.black87,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        height: 1.333,
      )})
      : super(
          attachmentButtonIcon: attachmentButtonIcon,
          backgroundColor: backgroundColor,
          dateDividerTextStyle: dateDividerTextStyle,
          deliveredIcon: deliveredIcon,
          documentIcon: documentIcon,
          emptyChatPlaceholderTextStyle: emptyChatPlaceholderTextStyle,
          errorColor: errorColor,
          errorIcon: errorIcon,
          inputBackgroundColor: inputBackgroundColor,
          inputBorderRadius: inputBorderRadius,
          inputTextColor: inputTextColor,
          inputTextStyle: inputTextStyle,
          messageBorderRadius: messageBorderRadius,
          primaryColor: primaryColor,
          receivedMessageBodyTextStyle: receivedMessageBodyTextStyle,
          receivedMessageCaptionTextStyle: receivedMessageCaptionTextStyle,
          receivedMessageDocumentIconColor: receivedMessageDocumentIconColor,
          receivedMessageLinkDescriptionTextStyle:
              receivedMessageLinkDescriptionTextStyle,
          receivedMessageLinkTitleTextStyle: receivedMessageLinkTitleTextStyle,
          secondaryColor: secondaryColor,
          seenIcon: seenIcon,
          sendButtonIcon: sendButtonIcon,
          sendingIcon: sendingIcon,
          sentMessageBodyTextStyle: sentMessageBodyTextStyle,
          sentMessageCaptionTextStyle: sentMessageCaptionTextStyle,
          sentMessageDocumentIconColor: sentMessageDocumentIconColor,
          sentMessageLinkDescriptionTextStyle:
              sentMessageLinkDescriptionTextStyle,
          sentMessageLinkTitleTextStyle: sentMessageLinkTitleTextStyle,
          userAvatarNameColors: userAvatarNameColors,
          userAvatarTextStyle: userAvatarTextStyle,
          userNameTextStyle: userNameTextStyle,
          attachmentButtonMargin: null,
          dateDividerMargin: EdgeInsets.zero,
          inputMargin: EdgeInsets.zero,
          inputPadding: EdgeInsets.zero,
          inputTextDecoration: const InputDecoration(),
          messageInsetsHorizontal: 4,
          messageInsetsVertical: 4,
          receivedEmojiMessageTextStyle: const TextStyle(),
          sendButtonMargin: null,
          sentEmojiMessageTextStyle: const TextStyle(),
          statusIconPadding: const EdgeInsets.symmetric(),
          systemMessageTheme: const SystemMessageTheme(
              margin: EdgeInsets.zero, textStyle: TextStyle()),
          typingIndicatorTheme: const TypingIndicatorTheme(
              animatedCirclesColor: Colors.blue,
              animatedCircleSize: 5,
              bubbleBorder: BorderRadius.zero,
              bubbleColor: Colors.lightBlue,
              countAvatarColor: Colors.blue,
              countTextColor: Colors.black,
              multipleUserTextStyle: TextStyle()),
          unreadHeaderTheme: const UnreadHeaderTheme(
              color: Colors.black, textStyle: TextStyle()),
          userAvatarImageBackgroundColor: Colors.transparent,
          inputSurfaceTintColor: Colors.black,
          inputElevation: 2,
          messageMaxWidth: 300,
        );
}
