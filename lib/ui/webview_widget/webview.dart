import 'dart:convert';
import 'dart:io';
import 'package:doo_cx_flutter_sdk/ui/webview_widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'
    as webview_flutter_android;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'
    as webview_flutter_wkwebview;

import '../../data/local/entity/doo_user.dart';

///DOO webview widget
/// {@category FlutterClientSdk}
class Webview extends StatefulWidget {
  /// Url for DOO widget in webview
  late final String widgetUrl;

  /// DOO user & locale initialisation script
  late final String injectedJavaScript;

  /// See [DOOWidget.closeWidget]
  final void Function()? closeWidget;

  /// See [DOOWidget.onAttachFile]
  final Future<List<String>> Function()? onAttachFile;

  /// See [DOOWidget.onLoadStarted]
  final void Function()? onLoadStarted;

  /// See [DOOWidget.onLoadProgress]
  final void Function(int)? onLoadProgress;

  /// See [DOOWidget.onLoadCompleted]
  final void Function()? onLoadCompleted;

  Webview(
      {Key? key,
      required String websiteToken,
      required String baseUrl,
      DOOUser? user,
      String locale = "en",
      customAttributes,
      this.closeWidget,
      this.onAttachFile,
      this.onLoadStarted,
      this.onLoadProgress,
      this.onLoadCompleted})
      : super(key: key) {
    widgetUrl =
        "${baseUrl}/widget?website_token=${websiteToken}&locale=${locale}";

    injectedJavaScript = generateScripts(
        user: user, locale: locale, customAttributes: customAttributes);
  }

  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition on Android
    if (Platform.isAndroid) {
      WebViewPlatform.instance =
          webview_flutter_android.AndroidWebViewPlatform();
    } else if (Platform.isIOS) {
      WebViewPlatform.instance =
          webview_flutter_wkwebview.WebKitWebViewPlatform();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String webviewUrl = widget.widgetUrl;
      final cwCookie = await StoreHelper.getCookie();
      if (cwCookie.isNotEmpty) {
        webviewUrl = "${webviewUrl}&cw_conversation=${cwCookie}";
      }
      setState(() {
        _controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.white)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
                widget.onLoadProgress?.call(progress);
              },
              onPageStarted: (String url) {
                widget.onLoadStarted?.call();
              },
              onPageFinished: (String url) async {
                widget.onLoadCompleted?.call();
              },
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('file://')) {
                  _handleFileSelection();
                  return NavigationDecision.prevent;
                }
                _goToUrl(request.url);
                return NavigationDecision.prevent;
              },
            ),
          )
          ..addJavaScriptChannel("ReactNativeWebView",
              onMessageReceived: (JavaScriptMessage jsMessage) {
            print("DOO message received: ${jsMessage.message}");
            final message = getMessage(jsMessage.message);
            if (isJsonString(message)) {
              final parsedMessage = jsonDecode(message);
              final eventType = parsedMessage["event"];
              final type = parsedMessage["type"];
              if (eventType == 'loaded') {
                final authToken = parsedMessage["config"]["authToken"];
                StoreHelper.storeCookie(authToken);
                _controller?.runJavaScript(widget.injectedJavaScript);
              }
              if (type == 'close-widget') {
                widget.closeWidget?.call();
              }
            }
          })
          ..loadRequest(Uri.parse(webviewUrl));

        if (Platform.isAndroid) {
          final androidController = _controller!.platform
              as webview_flutter_android.AndroidWebViewController;
          androidController
              .setOnShowFileSelector((_) => widget.onAttachFile!.call());
        } else if (Platform.isIOS) {
          final iOSController = _controller!.platform
              as webview_flutter_wkwebview.WebKitWebViewController;
          iOSController.setAllowsBackForwardNavigationGestures(false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller != null
        ? WebViewWidget(controller: _controller!)
        : SizedBox();
  }

  void _goToUrl(String url) {
    launchUrl(Uri.parse(url));
  }

  void _handleFileSelection() async {
    if (widget.onAttachFile != null) {
      List<String> files = await widget.onAttachFile!();
      if (files.isNotEmpty) {
        String fileList = files.map((file) => '"$file"').join(',');
        String script =
            'window.postMessage({"type": "file-selected", "files": [$fileList]});';
        _controller?.runJavaScript(script);
      }
    }
  }
}
