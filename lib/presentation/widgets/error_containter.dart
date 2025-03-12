import 'package:flutter/material.dart';
import 'package:road_oper_app/core/constants/color_constants.dart';

class ErrorContainter extends StatelessWidget {
  final VoidCallback onRetryPressed;

  const ErrorContainter({
    super.key,
    required this.onRetryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 64, color: AppColors.kColorGreen100),
            const SizedBox(height: 16),
            Text(
              'Проблема с подключением',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.kColorWhite10,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetryPressed,
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.kColorBlack90,
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 32,
                ),
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Повторить попытку'),
            ),
          ],
        ),
      ),
    );
  }
}
