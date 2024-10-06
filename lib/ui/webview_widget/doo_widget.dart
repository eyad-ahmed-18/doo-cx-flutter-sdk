import 'package:doo_cx_flutter_sdk/data/local/entity/doo_user.dart';
import 'package:doo_cx_flutter_sdk/ui/webview_widget/webview.dart';
import 'package:flutter/material.dart';

///DOOWidget
/// {@category FlutterClientSdk}
class DOOWidget extends StatefulWidget {
  ///Website channel token
  final String websiteToken;

  ///Installation url for DOO
  final String baseUrl;

  ///User information about the user like email, username and avatar_url
  final DOOUser? user;

  ///User locale
  final String locale;

  ///Widget Close event
  final void Function()? closeWidget;

  ///Additional information about the customer
  final customAttributes;

  ///Widget Attachment event. Currently supported only on Android devices
  final Future<List<String>> Function()? onAttachFile;

  ///Widget Load started event
  final void Function()? onLoadStarted;

  ///Widget Load progress event
  final void Function(int)? onLoadProgress;

  ///Widget Load completed event
  final void Function()? onLoadCompleted;
  DOOWidget(
      {Key? key,
      required this.websiteToken,
      required this.baseUrl,
      this.user,
      this.locale = "en",
      this.customAttributes,
      this.closeWidget,
      this.onAttachFile,
      this.onLoadStarted,
      this.onLoadProgress,
      this.onLoadCompleted})
      : super(key: key);

  @override
  _DOOWidgetState createState() => _DOOWidgetState();
}

class _DOOWidgetState extends State<DOOWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Webview(
      websiteToken: widget.websiteToken,
      baseUrl: widget.baseUrl,
      user: widget.user,
      locale: widget.locale,
      customAttributes: widget.customAttributes,
      closeWidget: widget.closeWidget,
      onAttachFile: widget.onAttachFile,
      onLoadStarted: widget.onLoadStarted,
      onLoadCompleted: widget.onLoadCompleted,
      onLoadProgress: widget.onLoadProgress,
    );
  }
}
