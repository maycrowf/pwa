import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_oper_app/core/constants/constants.dart';
import 'package:road_oper_app/presentation/cubit/location_cubit.dart';
import 'package:road_oper_app/presentation/cubit/web_view_cubit.dart';
import 'package:road_oper_app/presentation/widgets/error_containter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OperWebScreen extends StatelessWidget {
  const OperWebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final webViewCubit = context.read<WebViewCubit>();
    final locationCubit = context.read<LocationCubit>();

    void onPopInvoked(bool didPop, dynamic result) async {
      context.read<WebViewCubit>().popWebView(
            context: context,
            didPop: didPop,
            result: result,
          );
    }

    webViewCubit.initWebView(
      onPageFinished: locationCubit.startUpdateAndSendLocation,
    );

    return BlocBuilder<WebViewCubit, WebViewState>(
      builder: (context, state) {
        if (state.hasError) {
          return ErrorContainter(
            onRetryPressed: context.read<WebViewCubit>().retryConnection,
          );
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: onPopInvoked,
          child: Scaffold(
            backgroundColor: AppColors.kColorBlack100,
            body: WebViewWidget(
              key: UniqueKey(),
              controller: context.read<WebViewCubit>().controller,
              gestureRecognizers: {
                Factory(() => VerticalDragGestureRecognizer()),
              },
            ),
          ),
        );
      },
    );
  }
}
