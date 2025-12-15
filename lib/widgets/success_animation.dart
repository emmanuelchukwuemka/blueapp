import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../config/theme.dart';

class SuccessAnimation extends StatelessWidget {
  final String message;
  final String? animationAsset;
  final double size;

  const SuccessAnimation({
    super.key,
    required this.message,
    this.animationAsset = 'assets/animations/success.json',
    this.size = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Lottie.asset(
              animationAsset,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}