import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Center nav-bar button on the home page: opens the "unlock course" sheet.
class HomePageCenterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const HomePageCenterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: TextButton.icon(
          onPressed: onPressed,
          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8)),
          icon: const Icon(Icons.lock_open, size: 16, color: AppColors.primary),
          label: const Text(
            'Odblokuj kurs',
            maxLines: 1,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
