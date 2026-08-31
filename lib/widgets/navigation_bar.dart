import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;
  final Widget? centerWidget;
  final bool enableLeftButton;
  final bool enableRightButton;

  const BottomNavBar({
    super.key,
    required this.onLeftPressed,
    required this.onRightPressed,
    this.centerWidget,
    this.enableLeftButton = true,
    this.enableRightButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: [
          // Left - Previous button
          Expanded(
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Poprzednia strona',
                color: enableLeftButton ? AppColors.primary : Colors.grey[400],
                iconSize: 20,
                onPressed: enableLeftButton ? onLeftPressed : null,
              ),
            ),
          ),
          // Center - Configurable widget
          Expanded(child: centerWidget ?? Container()),
          // Right - Next button
          Expanded(
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                tooltip: 'Następna strona',
                color: enableRightButton ? AppColors.primary : Colors.grey[400],
                iconSize: 20,
                onPressed: enableRightButton ? onRightPressed : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
