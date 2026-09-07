import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_courses.dart';
import '../models/course.dart';

/// Result of trying to redeem an unlock code.
enum UnlockResult { success, invalidCode, alreadyUsed }

/// A code an admin generated for a course, with its redemption state.
class IssuedCode {
  final String code;
  final String courseId;
  final bool used;

  const IssuedCode({required this.code, required this.courseId, required this.used});
}

/// Abstraction over "which courses does this account have, and which lessons
/// has it watched". The PoC implementation below stores everything on-device
/// with SharedPreferences, scoped per logged-in account; a later
/// FirestoreCourseRepository can implement the same interface (reading the
/// user's own document) without touching any UI code.
abstract class CourseRepository {
  List<Course> get allCourses;

  /// Scopes unlocked/watched state to this account. Call right after login
  /// (and again on every app start once the session is restored) so a
  /// switched account always sees its own course list, never a stale one.
  void setCurrentUser(String email);

  Future<Set<String>> getUnlockedCourseIds();
  Future<Set<String>> getWatchedLessonIds();

  Future<UnlockResult> redeemCode(String code);
  Future<void> setLessonWatched(String lessonId, bool watched);

  /// Admin-only: generates up to [count] fresh unlock codes for [courseId]
  /// (clamped to [LocalCourseRepository.maxCodesPerBatch] per call, and
  /// further capped so the course never has more than
  /// [LocalCourseRepository.maxActiveCodesPerCourse] unused codes at once —
  /// may return fewer codes than requested, or none, if that cap is hit).
  Future<List<String>> generateCodes(String courseId, {int count = 1});

  /// Admin-only: all codes generated so far, newest first.
  Future<List<IssuedCode>> getIssuedCodes();
}

/// Shared repository instance used throughout the app.
/// Swap the assignment below for a FirestoreCourseRepository() once the
/// Firestore backend exists.
final CourseRepository courseRepository = LocalCourseRepository();

class LocalCourseRepository implements CourseRepository {
  static const _keyUnlockedCourses = 'unlocked_course_ids';
  static const _keyWatchedLessons = 'watched_lesson_ids';
  static const _keyUsedCodes = 'used_unlock_codes';
  static const _keyIssuedCodes = 'issued_unlock_codes';
  static const _codeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static const maxCodesPerBatch = 30;
  static const maxActiveCodesPerCourse = 100;

  String? _currentUserEmail;

  @override
  void setCurrentUser(String email) {
    _currentUserEmail = email.trim().toLowerCase();
  }

  /// Per-account key: unlocked courses and watched lessons must never leak
  /// between accounts on the same device. Codes (issued/used) stay global —
  /// a code is redeemed once, account-independent.
  String _scoped(String key) {
    final email = _currentUserEmail;
    assert(email != null, 'setCurrentUser() must be called before using CourseRepository');
    return '$key:${email ?? 'unknown'}';
  }

  @override
  List<Course> get allCourses => mockCourses;

  @override
  Future<Set<String>> getUnlockedCourseIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_scoped(_keyUnlockedCourses)) ?? []).toSet();
  }

  @override
  Future<Set<String>> getWatchedLessonIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_scoped(_keyWatchedLessons)) ?? []).toSet();
  }

  Future<Map<String, String>> _loadIssuedCodes(SharedPreferences prefs) async {
    final entries = prefs.getStringList(_keyIssuedCodes) ?? [];
    return {
      for (final entry in entries)
        entry.split('|').first: entry.split('|').last,
    };
  }

  Future<void> _saveIssuedCodes(SharedPreferences prefs, Map<String, String> codes) async {
    await prefs.setStringList(
      _keyIssuedCodes,
      codes.entries.map((e) => '${e.key}|${e.value}').toList(),
    );
  }

  @override
  Future<List<String>> generateCodes(String courseId, {int count = 1}) async {
    final prefs = await SharedPreferences.getInstance();
    final issued = await _loadIssuedCodes(prefs);
    final usedCodes = (prefs.getStringList(_keyUsedCodes) ?? []).toSet();
    final random = Random.secure();

    final activeForCourse = issued.entries
        .where((e) => e.value == courseId && !usedCodes.contains(e.key))
        .length;
    final remainingCapacity = (maxActiveCodesPerCourse - activeForCourse).clamp(0, maxCodesPerBatch);
    final batchSize = count.clamp(1, maxCodesPerBatch).clamp(0, remainingCapacity);

    final generated = <String>[];
    for (var i = 0; i < batchSize; i++) {
      String code;
      do {
        code = List.generate(8, (_) => _codeChars[random.nextInt(_codeChars.length)]).join();
      } while (issued.containsKey(code));

      issued[code] = courseId;
      generated.add(code);
    }

    await _saveIssuedCodes(prefs, issued);
    return generated;
  }

  @override
  Future<List<IssuedCode>> getIssuedCodes() async {
    final prefs = await SharedPreferences.getInstance();
    final issued = await _loadIssuedCodes(prefs);
    final usedCodes = (prefs.getStringList(_keyUsedCodes) ?? []).toSet();
    return issued.entries
        .map((e) => IssuedCode(code: e.key, courseId: e.value, used: usedCodes.contains(e.key)))
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<UnlockResult> redeemCode(String code) async {
    final normalized = code.trim().toUpperCase();
    final prefs = await SharedPreferences.getInstance();
    final usedCodes = (prefs.getStringList(_keyUsedCodes) ?? []).toSet();

    if (usedCodes.contains(normalized)) {
      return UnlockResult.alreadyUsed;
    }
    final issued = await _loadIssuedCodes(prefs);
    final courseId = issued[normalized];
    if (courseId == null) {
      return UnlockResult.invalidCode;
    }

    usedCodes.add(normalized);
    await prefs.setStringList(_keyUsedCodes, usedCodes.toList());

    final unlocked = await getUnlockedCourseIds();
    unlocked.add(courseId);
    await prefs.setStringList(_scoped(_keyUnlockedCourses), unlocked.toList());

    return UnlockResult.success;
  }

  @override
  Future<void> setLessonWatched(String lessonId, bool watched) async {
    final prefs = await SharedPreferences.getInstance();
    final watchedIds = await getWatchedLessonIds();
    if (watched) {
      watchedIds.add(lessonId);
    } else {
      watchedIds.remove(lessonId);
    }
    await prefs.setStringList(_scoped(_keyWatchedLessons), watchedIds.toList());
  }
}
