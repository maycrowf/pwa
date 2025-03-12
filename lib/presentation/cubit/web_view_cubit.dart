import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_oper_app/core/constants/config.dart';
import 'package:road_oper_app/core/services/web_view_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

//* Cubit
class WebViewCubit extends Cubit<WebViewState> {
  final WebViewService _webViewService;

  WebViewCubit(this._webViewService) : super(WebViewState());

  void initWebView({VoidCallback? onPageFinished}) {
    _webViewService.init(
      url: Config.baseUrl,
      onPageFinished: (_) {
        emit(WebViewState());
        if (onPageFinished != null) {
          onPageFinished();
        }
      },
      onError: (error) => emit(WebViewState(
        hasError: true,
        error: error,
      )),
    );
  }

  WebViewController get controller => _webViewService.controller;

  void retryConnection() {
    _webViewService.reload();
    emit(WebViewState());
  }

  Future<void> popWebView({
    required BuildContext context,
    required bool didPop,
    required dynamic result,
  }) async {
    if (didPop) return;
    final navigator = Navigator.of(context);

    if (state.hasError) {
      navigator.pop(result);
      return;
    }

    final currentUrl = await _webViewService.controller.currentUrl();

    if (currentUrl != null && currentUrl.contains('/journal')) {
      navigator.pop(result);
      return;
    }

    if (await _webViewService.controller.canGoBack()) {
      _webViewService.controller.goBack();
      return;
    }

    navigator.pop(result);
  }
}

//* State
class WebViewState extends Equatable {
  final bool hasError;
  final WebResourceError? error;

  const WebViewState({
    this.hasError = false,
    this.error,
  });

  @override
  List<Object?> get props => [hasError, error];
}
