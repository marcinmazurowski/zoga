import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/lesson.dart';
import '../services/course_repository.dart';
import '../theme/app_colors.dart';
import 'video_player_page.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  Set<String> _watchedIds = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final watched = await courseRepository.getWatchedLessonIds();
    setState(() {
      _watchedIds = watched;
      _loading = false;
    });
  }

  Future<void> _openLesson(Lesson lesson) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => VideoPlayerPage(lesson: lesson)),
    );
    // Mark as watched once the user has opened the video; can still be
    // toggled manually from the switch below.
    await _setWatched(lesson.id, true);
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
                      lesson: lesson,
                      watched: _watchedIds.contains(lesson.id),
                      onTap: () => _openLesson(lesson),
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
  final VoidCallback onTap;
  final ValueChanged<bool> onWatchedChanged;

  const _LessonTile({
    required this.lesson,
    required this.watched,
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
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          lesson.source == VideoSource.youtube ? Icons.smart_display_outlined : Icons.folder_shared_outlined,
          color: AppColors.primary,
        ),
        title: Text(
          lesson.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            decoration: watched ? TextDecoration.lineThrough : null,
            decorationColor: AppColors.textSecondary,
          ),
        ),
        subtitle: Text(
          lesson.source == VideoSource.youtube ? 'YouTube' : 'Google Drive',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: Switch(
          value: watched,
          activeThumbColor: AppColors.primary,
          onChanged: onWatchedChanged,
        ),
      ),
    );
  }
}
