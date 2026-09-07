import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/lesson.dart';
import '../services/course_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/lesson_search_bar.dart';
import 'course_detail_page.dart';

class HomePage extends StatefulWidget {
  /// Signs the account out so a different one can log in.
  final VoidCallback onLogout;

  const HomePage({super.key, required this.onLogout});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Set<String> _unlockedIds = {};
  Set<String> _watchedIds = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    final unlocked = await courseRepository.getUnlockedCourseIds();
    final watched = await courseRepository.getWatchedLessonIds();
    if (!mounted) return;
    setState(() {
      _unlockedIds = unlocked;
      _watchedIds = watched;
      _loading = false;
    });
  }

  /// Courses this account has actually unlocked — the search bar reads this
  /// too, so it only ever offers lessons the user can already watch.
  List<Course> get unlockedCourses =>
      courseRepository.allCourses.where((c) => _unlockedIds.contains(c.id)).toList();

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Zmienić konto?'),
        content: const Text('Zostaniesz wylogowany i poproszony o ponowne zalogowanie się przez email.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Wyloguj'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      widget.onLogout();
    }
  }

  Future<void> openCourse(BuildContext context, Course course, {Lesson? initialLesson}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CourseDetailPage(course: course, initialLesson: initialLesson),
      ),
    );
    refresh();
  }

  void _onSelectLesson(Course course, Lesson lesson) =>
      openCourse(context, course, initialLesson: lesson);

  @override
  Widget build(BuildContext context) {
    final courses = unlockedCourses;

    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Twoje kursy',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Zoga Multidimensional Movement',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 4,
                    child: IconButton(
                      tooltip: 'Wyloguj / zmień konto',
                      icon: const Icon(Icons.logout, color: AppColors.textSecondary),
                      onPressed: () => _confirmLogout(context),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: refresh,
                      child: courses.isEmpty
                          ? _EmptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.all(20),
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                final course = courses[index];
                                final watchedCount = course.lessons
                                    .where((l) => _watchedIds.contains(l.id))
                                    .length;
                                return _CourseCard(
                                  course: course,
                                  watchedCount: watchedCount,
                                  onTap: () => openCourse(context, course),
                                );
                              },
                            ),
                    ),
            ),
            LessonSearchBar(
              courses: courses,
              onSelectLesson: _onSelectLesson,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 56, color: AppColors.locked),
                const SizedBox(height: 16),
                const Text(
                  'Nie masz jeszcze żadnych kursów',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Użyj przycisku "Odblokuj kurs" na dole ekranu i wpisz kod otrzymany od Zoga Multidimensional Movement.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  final int watchedCount;
  final VoidCallback onTap;

  const _CourseCard({
    required this.course,
    required this.watchedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primary,
                  child: Icon(course.icon, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Obejrzano $watchedCount z ${course.lessons.length}',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
