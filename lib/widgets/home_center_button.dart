import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HomePageCenterButton extends StatelessWidget {
  final ValueNotifier<bool> expandedNotifier;
  final VoidCallback onToggle;

  const HomePageCenterButton({
    super.key,
    required this.expandedNotifier,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: expandedNotifier,
      builder: (context, isExpanded, _) {
        return Center(
          child: TextButton(
            onPressed: onToggle,
            child: Text(
              isExpanded ? 'Pokaż mniej' : 'Pokaż więcej',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
