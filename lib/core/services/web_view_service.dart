import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

class WebViewService {
  late WebViewController _controller;

  WebViewController get controller => _controller;

  void init({
    required String url,
    required Function(String)? onPageFinished,
    required Function(WebResourceError) onError,
  }) {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: onPageFinished,
        onWebResourceError: onError,
      ))
      ..loadRequest(Uri.parse(url));
  }

  Future<String?> getCurrentUrl() async => _controller.currentUrl();

  Future<void> reload() async => _controller.reload();

  Future<bool> canGoBack() async {
    return _controller.canGoBack();
  }

  Future<void> goBack() async => _controller.goBack();

  void sendLocationToWeb({
    required double lat,
    required double lon,
    required double heading,
  }) {
    final locationData = jsonEncode({
      'latitude': lat,
      'longitude': lon,
      'heading': heading,
    });

    _controller.runJavaScript("window.updateLocation($locationData);");
  }
}
