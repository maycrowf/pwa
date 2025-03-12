import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:road_oper_app/core/constants/constants.dart';
import 'package:road_oper_app/presentation/widgets/error_containter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OperWebScreen extends StatefulWidget {
  const OperWebScreen({super.key});

  @override
  State<OperWebScreen> createState() => _OperWebScreenState();
}

class _OperWebScreenState extends State<OperWebScreen> {
  final Set<Factory<OneSequenceGestureRecognizer>> _gestureRecognizers = {
    Factory(() => VerticalDragGestureRecognizer()),
  };
  final UniqueKey _key = UniqueKey();

  final _locationRepository = GetIt.I<ILocationRepository>();
  late WebViewController _controller;
  double heading = 0;
  bool hasError = false;

  StreamSubscription<Position>? _locationSubscription;
  StreamSubscription<CompassEvent>? _directionSubscription;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          _startLocationUpdates();
        },
        onWebResourceError: _handleWebError,
      ))
      ..loadRequest(Uri.parse(baseUrl));
  }

  Future<void> _startLocationUpdates() async {
    await _locationRepository.requestPermission();

    _locationSubscription?.cancel();
    _directionSubscription?.cancel();

    _locationSubscription = _locationRepository.getLocationStream().listen(
      (Position position) {
        _sendLocationToWeb(position.latitude, position.longitude, heading);
      },
    );

    _directionSubscription =
        _locationRepository.getDirectionStream()?.listen((compassEvent) {
      if (compassEvent.heading == null) return;
      heading = compassEvent.heading!;
    });
  }

  void _sendLocationToWeb(double lat, double lon, double heading) {
    final locationData = jsonEncode({
      'latitude': lat,
      'longitude': lon,
      'heading': heading,
    });
    _controller.runJavaScript("window.updateLocation($locationData);");
  }

  void _onWillPop(bool didPop, dynamic result) async {
    if (didPop) return;
    final navigator = Navigator.of(context);

    if (hasError) {
      navigator.pop(result);
      return;
    }

    final currentUrl = await _controller.currentUrl();

    if (currentUrl != null && currentUrl.contains('/journal')) {
      navigator.pop(result);
      return;
    }

    if (await _controller.canGoBack()) {
      _controller.goBack();
      return;
    }

    navigator.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.kColorBlack100,
        body: hasError
            ? ErrorContainter(onRetryPressed: _retryConnection)
            : WebViewWidget(
                key: _key,
                controller: _controller,
                gestureRecognizers: _gestureRecognizers,
              ),
      ),
    );
  }

  void _retryConnection() {
    _controller.reload();
    setState(() => hasError = false);
  }

  void _handleWebError(WebResourceError error) {
    if (error.errorCode != -2) return;
    setState(() => hasError = true);
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _directionSubscription?.cancel();
    super.dispose();
  }
}
