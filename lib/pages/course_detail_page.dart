import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/lesson.dart';
import '../services/course_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/inline_video_player.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;

  /// When set, this lesson is expanded (and scrolled into view)
  /// automatically — used when arriving here from the lesson search.
  final Lesson? initialLesson;

  const CourseDetailPage({super.key, required this.course, this.initialLesson});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  Set<String> _watchedIds = {};
  String? _expandedLessonId;
  bool _loading = true;
  final Map<String, GlobalKey> _lessonKeys = {};

  @override
  void initState() {
    super.initState();
    _expandedLessonId = widget.initialLesson?.id;
    for (final lesson in widget.course.lessons) {
      _lessonKeys[lesson.id] = GlobalKey();
    }
    _load();
  }

  Future<void> _load() async {
    final watched = await courseRepository.getWatchedLessonIds();
    if (widget.initialLesson != null) {
      await courseRepository.setLessonWatched(widget.initialLesson!.id, true);
      watched.add(widget.initialLesson!.id);
    }
    setState(() {
      _watchedIds = watched;
      _loading = false;
    });
    if (widget.initialLesson != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = _lessonKeys[widget.initialLesson!.id]?.currentContext;
        if (context != null) {
          Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 300));
        }
      });
    }
  }

  void _toggleLesson(Lesson lesson) {
    setState(() {
      _expandedLessonId = _expandedLessonId == lesson.id ? null : lesson.id;
    });
    if (_expandedLessonId == lesson.id) {
      // Mark as watched once the user expands the video; can still be
      // toggled manually from the switch below.
      _setWatched(lesson.id, true);
    }
  }

  Future<void> _setWatched(String lessonId, bool watched) async {
    await courseRepository.setLessonWatched(lessonId, watched);
    setState(() {
      if (watched) {
        _watchedIds.add(lessonId);
      } else {
        _watchedIds.remove(lessonId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final watchedCount = course.lessons.where((l) => _watchedIds.contains(l.id)).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text(
          course.title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  course.description,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  'Obejrzano $watchedCount z ${course.lessons.length}',
                  style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ...course.lessons.map((lesson) => _LessonTile(
                      key: _lessonKeys[lesson.id],
                      lesson: lesson,
                      watched: _watchedIds.contains(lesson.id),
                      expanded: _expandedLessonId == lesson.id,
                      onTap: () => _toggleLesson(lesson),
                      onWatchedChanged: (value) => _setWatched(lesson.id, value),
                    )),
              ],
            ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final Lesson lesson;
  final bool watched;
  final bool expanded;
  final VoidCallback onTap;
  final ValueChanged<bool> onWatchedChanged;

  const _LessonTile({
    super.key,
    required this.lesson,
    required this.watched,
    required this.expanded,
    required this.onTap,
    required this.onWatchedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Icon(
              lesson.source == VideoSource.youtube ? Icons.smart_display_outlined : Icons.folder_shared_outlined,
              color: AppColors.primary,
            ),
            title: Text(
              lesson.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: watched,
                  activeThumbColor: AppColors.primary,
                  onChanged: onWatchedChanged,
                ),
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          if (expanded) InlineVideoPlayer(lesson: lesson),
        ],
      ),
    );
  }
}
