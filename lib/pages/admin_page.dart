import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_repository.dart';
import '../theme/app_colors.dart';

/// Admin-only screen for generating course unlock codes.
/// Only reachable when the logged-in account is an admin.
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Course? _selectedCourse;
  int _quantity = 1;
  String? _limitMessage;
  bool _generating = false;
  List<IssuedCode> _issuedCodes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selectedCourse = courseRepository.allCourses.first;
    _loadIssuedCodes();
  }

  Future<void> _loadIssuedCodes() async {
    final codes = await courseRepository.getIssuedCodes();
    if (!mounted) return;
    setState(() {
      _issuedCodes = codes;
      _loading = false;
    });
  }

  void _setQuantity(int value) {
    setState(() => _quantity = value.clamp(1, LocalCourseRepository.maxCodesPerBatch));
  }

  Future<void> _generate() async {
    final course = _selectedCourse;
    if (course == null) return;
    setState(() {
      _generating = true;
      _limitMessage = null;
    });
    final generated = await courseRepository.generateCodes(course.id, count: _quantity);
    if (!mounted) return;
    setState(() {
      _generating = false;
      if (generated.length < _quantity) {
        _limitMessage = generated.isEmpty
            ? 'Osiągnięto maksymalny limit ${LocalCourseRepository.maxActiveCodesPerCourse} aktywnych kodów.'
            : 'Wygenerowano tylko ${generated.length} — osiągnięto maksymalny limit ${LocalCourseRepository.maxActiveCodesPerCourse} aktywnych kodów.';
      }
    });
    await _loadIssuedCodes();
  }

  String _courseTitle(String courseId) {
    for (final course in courseRepository.allCourses) {
      if (course.id == courseId) return course.title;
    }
    return courseId;
  }

  @override
  Widget build(BuildContext context) {
    final activeCodes = _issuedCodes
        .where((c) => !c.used && c.courseId == _selectedCourse?.id)
        .toList();

    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Panel admina',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            const Text(
              'Generowanie kodów dostępu do kursów',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kurs',
                                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<Course>(
                                initialValue: _selectedCourse,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                items: courseRepository.allCourses
                                    .map((c) => DropdownMenuItem(value: c, child: Text(c.title)))
                                    .toList(),
                                onChanged: (course) => setState(() => _selectedCourse = course),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Liczba kodów',
                                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [1, 5, 10, 20, LocalCourseRepository.maxCodesPerBatch]
                                    .map((value) => Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            child: _QuantityOption(
                                              value: value,
                                              selected: _quantity == value,
                                              onTap: () => _setQuantity(value),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _generating ? null : _generate,
                                  icon: const Icon(Icons.qr_code_2),
                                  label: Text(_generating
                                      ? 'Generowanie…'
                                      : _quantity == 1
                                          ? 'Wygeneruj kod'
                                          : 'Wygeneruj $_quantity kodów'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                              if (_limitMessage != null) ...[
                                const SizedBox(height: 10),
                                Text(
                                  _limitMessage!,
                                  style: const TextStyle(fontSize: 12, color: AppColors.error),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Aktywne kody',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 12),
                        if (activeCodes.isEmpty)
                          const Text(
                            'Brak aktywnych kodów dla tego kursu.',
                            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                          )
                        else
                          ...activeCodes.map(
                            (issued) => Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          issued.code,
                                          style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1),
                                        ),
                                        Text(
                                          _courseTitle(issued.courseId),
                                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Aktywny',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityOption extends StatelessWidget {
  final int value;
  final bool selected;
  final VoidCallback onTap;

  const _QuantityOption({required this.value, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.accentLight : AppColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.divider.withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            '$value',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
