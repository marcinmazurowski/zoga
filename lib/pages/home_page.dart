import 'package:flutter/material.dart';
import '../data/temp_data.dart';
import '../theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const int _initialCount = 3;
  static const int _expandedCount = 6;

  final ValueNotifier<bool> expandedNotifier = ValueNotifier(false);
  late final List<TempEntry> _entries;

  @override
  void initState() {
    super.initState();
    _entries = tempEntries.take(_expandedCount).toList();
  }

  @override
  void dispose() {
    expandedNotifier.dispose();
    super.dispose();
  }

  void toggleExpanded() {
    expandedNotifier.value = !expandedNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.add_circle_outline,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Strona główna',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: expandedNotifier,
                builder: (context, isExpanded, _) {
                  final visibleEntries = isExpanded
                      ? _entries
                      : _entries.take(_initialCount).toList();
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: visibleEntries.length,
                    itemBuilder: (context, index) {
                      final entry = visibleEntries[index];
                      return Container(
                        key: ValueKey(entry.id),
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.secondary,
                              child: Text(
                                entry.author[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${entry.author} • ${entry.city}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
