import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/lesson.dart';
import '../theme/app_colors.dart';

class _LessonMatch {
  final Course course;
  final Lesson lesson;
  const _LessonMatch(this.course, this.lesson);
}

/// Search box docked just above the bottom nav-bar arrows: filters lessons
/// across the courses the user has already unlocked and jumps straight to
/// the matching course when a result is tapped.
class LessonSearchBar extends StatefulWidget {
  final List<Course> courses;
  final void Function(Course course, Lesson lesson) onSelectLesson;

  const LessonSearchBar({
    super.key,
    required this.courses,
    required this.onSelectLesson,
  });

  @override
  State<LessonSearchBar> createState() => _LessonSearchBarState();
}

class _LessonSearchBarState extends State<LessonSearchBar> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_LessonMatch> get _matches {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return const [];
    final results = <_LessonMatch>[];
    for (final course in widget.courses) {
      for (final lesson in course.lessons) {
        if (lesson.title.toLowerCase().contains(query)) {
          results.add(_LessonMatch(course, lesson));
        }
      }
    }
    return results;
  }

  void _select(_LessonMatch match) {
    widget.onSelectLesson(match.course, match.lesson);
    _controller.clear();
    setState(() => _query = '');
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final matches = _matches;
    final showResults = _query.trim().isNotEmpty;

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showResults)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -2)),
                ],
              ),
              child: matches.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Brak lekcji pasujących do wyszukiwania',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: matches.length,
                      separatorBuilder: (_, _) => Divider(height: 1, color: Colors.grey[200]),
                      itemBuilder: (context, index) {
                        final match = matches[index];
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            match.lesson.source == VideoSource.youtube
                                ? Icons.smart_display_outlined
                                : Icons.folder_shared_outlined,
                            color: AppColors.primary,
                          ),
                          title: Text(match.lesson.title, style: const TextStyle(fontSize: 14)),
                          subtitle: Text(
                            match.course.title,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          onTap: () => _select(match),
                        );
                      },
                    ),
            ),
          TextField(
            controller: _controller,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Szukaj lekcji…',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: showResults
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        _controller.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              isDense: true,
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
