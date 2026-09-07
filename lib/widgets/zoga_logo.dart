import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The client's logo mark plus wordmark, shown at the top of the login and
/// info screens.
class ZogaLogo extends StatelessWidget {
  final double fontSize;

  const ZogaLogo({super.key, this.fontSize = 32});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'lib/assets/logo.png',
          height: fontSize * 1.6,
          fit: BoxFit.contain,
        ),
        SizedBox(width: fontSize * 0.25),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: AppColors.primary,
            ),
            children: const [
              TextSpan(text: 'ZOGA'),
              TextSpan(
                text: '™',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
